---
title: "Developing file sync library"
date: 2024-11-29
weight: 80
summary: Alexey on a quest of solving recipe sync problem for Cooklang apps.
---

_Originally posted in our newsletter._

In this post I’m diving into the sync library I developed to keep recipes in sync across devices. This one's a bit technical, but if you’re curious about system design or want to peek into the process, you might find it interesting—and maybe even useful for your next interview! 😉

### The Problem

Initially, I launched a mobile app that used iCloud to sync recipes between desktop and mobile devices. It was a quick, get-things-done solution: to enable users to manage recipes in comfort of desktop, then use them on their mobile when cooking or shopping. However, iCloud comes with significant limitations—primarily that it only works between Mac and iPhone and offloads files from the phone to optimize storage, which is far from ideal for real-world use.

So, I needed to move away from this relationship and find a better solution.

### Finding the Right Library

Having worked in enterprise environments for a while (and have my brain permanently damaged), I started by listing my requirements. The library needed to:

* Work across Windows, Linux, macOS, Android, and iOS
* Be written in a cross-platform language like C or language with C-bindings support
* Support bi-directional sync
* Be lightweight, efficient, and secure
* Handle text file synchronization with near real-time updates
* Have a solid conflict resolution mechanism
* Bonus: Work with symlinks

With that list in hand, I started searching for an existing library. Here’s what I found and why I didn’t use each one:

|**Library**|**Description**|**Why Not?**|
|---|---|---|
|[librsync](https://github.com/librsync/librsync)|Calculates and applies network deltas.|Doesn’t include transport, complex dependencies.|
|[duet](https://github.com/mrzv/duet)|Bi-directional sync similar to Unison.|SSH transport only.|
|[LuminS](https://github.com/wchang22/LuminS)|Fast alternative to rsync for local files.|Only for local backups.|
|[bita](https://github.com/oll3/bita)|HTTP-based sync tool focused on low bandwidth.|Needs an archive shim to work.|
|[fast_rsync](https://github.com/dropbox/fast_rsync)|Faster rsync in pure Rust.|No transport layer.|
|[rustic](https://github.com/rustic-rs/rustic)|Backup tool with encryption and deduplication.|Requires extra setup to be useful.|
|[zbox](https://github.com/zboxfs/zbox)|Encrypted in-app file system.|Not accessible when the app isn’t running.|
|[Filer](https://github.com/shiveenp/Filer)|Rust service for cloud document syncing.|S3 backend only.|
|[NymDrive](https://github.com/gyrusdentatus/nymdrive)|Encrypted file sync over the Nym network.|Requires Nym network.|
|[rjrssync](https://github.com/Robert-Hughes/rjrssync)|Fast, rsync-like tool.|SSH transport only.|


### Building My Own Library

Lead by my foolhardiness and courage, Given the limitations of existing libraries, I decided to create a new library, something quick and dirty of course...Here’s what I aimed for:

* Low development effort. Keep it simple.
* Single-user edits. No collaboration is expected, so we can avoid complexities from it.
* Online editing. Assume users are mostly changing recipes when they have internet connection.
* Latest version priority. Since recipes are small, we can see the whole thing and hence favor the most recent edits.
* Server-centric. Not peer-to-peer, thanks.
* Automatic conflict resolution. No manual steps required.
* Tolerance for rare edit loss. Acceptable trade-off for simplicity.


### Conflict Resolution

Resolving conflicts in file synchronization is tricky, especially with multiple clients.

I forsee these operations that can happen and can cause conflicts:

* Add/remove/edit line in a file
* Create/remove file
* Move file between dirs
* Rename a file
* Create/remove a dir
* Client goes offline/online



Here’s a breakdown of potential strategies (thanks ChatGPT!):

|**Strategy**|**Approach**|**Pros**|**Cons**|
|---|---|---|---|
|Last Write Wins (LWW)|Latest timestamp wins.|Simple to implement.|Risk of losing important changes.|
|Version Vectors|Compare version numbers.|More accurate than LWW.|Complex to implement.|
|Operational Transformation (OT)|Transform concurrent operations.|Effective for collaborative editing.|Overkill for simple sync.|
|CRDTs|Merge data structures without conflicts.|Guarantees consistency.|High memory overhead, especially in dynamic languages.|
|Three-Way Merge|Use a common ancestor for merging.|Reduces data loss.|Requires file history tracking.|
|Application-Specific Rules|Tailored conflict rules.|Highly customized.|Requires deep understanding of the application.|
|User-Assisted Merging|Automatic merges with user fallback.|Balances automation with control.|Manual intervention can be time-consuming.|
|Hybrid Approaches|Combine methods based on context.|Flexible.|Increased complexity.|
|Semantic Sync|Understand file data semantics.|More accurate.|Requires detailed parsing.|
|Machine Learning|Predict best merge methods.|Improves over time.|High computational requirements.|



### Conflict Free Replicated Data Types

In my research, I initially decided to explore Conflict-Free Replicated Data Types (CRDTs). I had come across them in various blog posts, and they seemed both intriguing and sophisticated. If math—albeit a lot of math 🙄—can provide a solution that completely eliminates conflicts, why not give it a shot?

The concept behind CRDTs is to use specially designed data primitives and operations that can be safely merged to produce a consistent final state. It sounds ideal in theory. A good example of these data primitives can be found here: [https://github.com/aphyr/meangirls](https://github.com/aphyr/meangirls).

However, after experimenting with CRDTs, I realized that these primitives couldn't accurately represent the correct state of my recipes until all merges had fully propagated (or even in that case). CRDTs based on idea of order, and while in recipes files there an order of words but it based on our natural language and not really measurable for computing merges.

I'll leave it to the industry leaders to discuss this challenge in more detail:

> “Exactly, the "C" in CRDT is a little misleading. They are "conflict free" in as much as they are able to merge and resolve in the basic sense. That does not mean that the resulting state is valid or meets your internal schema.
> …
> Point is, it's still essential with CRDTs to have a schema and a validation/resolution process. That or you use completely custom CRDTs that encodes into their resolution process the validation of the schema.”
> Source: [https://news.ycombinator.com/item?id=33865672](https://news.ycombinator.com/item?id=33865672)

> “Figma isn't using true CRDTs. CRDTs are designed for decentralized systems where there is no single central authority to decide what the final state should be. There is some unavoidable performance and memory overhead with doing this. Since Figma is centralized (our server is the central authority), we can simplify our system by removing this extra overhead and benefit from a faster and leaner implementation.”
> Source: [https://www.figma.com/blog/how-figmas-multiplayer-technology-works/](https://www.figma.com/blog/how-figmas-multiplayer-technology-works/)

> “Apparently, everyone recognizes that CRDTs have a lot of potential, but concluded that the memory overhead of using them must be too expensive for real-world applications.”
> Source: [https://blog.kevinjahns.de/are-crdts-suitable-for-shared-editing/](https://blog.kevinjahns.de/are-crdts-suitable-for-shared-editing/)

After I dropped the idea of using CRDTs, I settled on a Server Wins strategy because it’s simple, minimizes surprises for users, and is resistant to issues from outdated clients.


### Choosing the Algorithm

I began by researching how others approach similar tasks. The first thing that came to mind was to examine how rsync functions. Rsync relies on the librsync library, which is responsible for efficiently comparing files and generating diffs. The rsync binary utilizes this library and adds transport capabilities via SSH.

Next, I explored a blog post on Dropbox ([https://dropbox.tech/infrastructure/streaming-file-synchronization](https://dropbox.tech/infrastructure/streaming-file-synchronization)) that detailed changes they made to their sync algorithm. Although the post didn’t provide complete details, it offered enough insight for me to understand the general process.

With this knowledge, I decided to implement my own Dropbox clone. If their approach works for them, it should work for me too. My implementation will only send the differences between files and include polling, allowing clients to subscribe and receive updates as needed. Now, let's delve into how this algorithm operates.

The system operates with both client-side and server-side components. Similar to rsync, the process involves splitting each file into chunks, with each chunk assigned an associated checksum. The server stores these checksums and maintains a journal that records all changes. When the client needs updates, it requests all changes since a specific journal reference ID.

![](https://mcusercontent.com/8ff03caaec446d167c7f72a3e/images/e38a6c47-e41c-db99-c3f3-f015217dfbde.png)

Dropbox uses fixed-size chunks (they mentioned a size of 4 MB). However, in my case, such large chunks would be inefficient because Cooklang primarily deals with text files, which are usually only a few kilobytes in size. Therefore, splitting them into such large chunks doesn't make sense. Instead, I decided to split text files at new line symbols, resulting in much smaller chunks.

Below is an example schema used by the journal to track file version history.

![](https://mcusercontent.com/8ff03caaec446d167c7f72a3e/images/2e41b9e2-e4ef-b25e-9f74-416dda79a8c8.png)

#### Upload flow

Let's start by considering the upload flow. First, we need to recognize that we have some local changes. We generate a list of hashes for the specific file and compare it with the one stored in local database previously coming from the server. If there's a mismatch, we submit the file to the server. However, the server might not have all the required hashes, so it could return a list of the missing ones. We then upload the requested hashes to the block storage (chunk server). Afterward, we attempt to commit again, and if successful, we receive a new journal ID. Finally, we store this journal ID along with the list of hashes in our client database.

![](https://mcusercontent.com/8ff03caaec446d167c7f72a3e/images/0fc10547-bb2e-3eb8-0d8f-c69291a48867.png)

#### Download flow

Now, let's examine how downloading works for clients who don't yet have the latest version of the recipe. A client will request the metaserver (journal server) to list all journal IDs since the last one stored locally. For example, if the last known journal ID was 15, the client will ask for ones more than 15. The metaserver then returns a list of files with their new hashes and corresponding journal IDs. The client proceeds to download the required chunks from the chunk server and stores them locally. Once all chunks are downloaded, the file can be reconstructed and replaced in the local file system.

![](https://mcusercontent.com/8ff03caaec446d167c7f72a3e/images/e7836ce7-67ae-609c-8360-e816eb9a890a.png)

### Conclusion

The library is open-source and available at [https://github.com/cooklang/cooklang-sync](https://github.com/cooklang/cooklang-sync). It’s still in draft form but is already serving Android alpha users. There might be some issues as it evolves, but I believe other projects could benefit from this simple sync mechanism.

What’s next? Features like rsync-style remote comparison, read-only sync, batch downloads, and security enhancements are on the horizon. For now, it syncs only selected file extensions.

Happy cooking!

-Alexey
