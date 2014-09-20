**NB still under active development, may not compile or make sense yet*

MMRecord With CoreData: example project
=======================================

I wanted to produce a reference project demonstrating how I often tackle certain aspects of writing iOS apps.

This is a simple example of how I lay out my networking code, including how to create manager classes to move logic out of the ViewController.


I'm firstly putting all my stuff in one project, and then I'll look at improving it, upgrading all cocoapod dependancies, and migrating it to Swift.

So far it demonstrates how to pull from a JSON API, catch network and JSON-level errors, deal with any JSON preprocessing that might be necessary (if the API is really serving us junk), then how to load the results into CoreData 

# Uses: 
- UISearchController for iOS8

- We don't use the `startRequestWithURN` networking built into MMRecord and instead roll our own using AFNetworking as described in this MutualMobile blog post: "[AFNetworking Response Serialization With MMRecord 1.2](http://mutualmobile.github.io/blog/2014/01/14/afnetworking-response-serialization-with-mmrecord-1-dot-2/)". This gives us a lot more flexibility, and has worked well in production. 

#Inspirations & Resources

- [Nice Web Services](commandshift.co.uk/blog/2014/01/02/nice-web-services/) blog post by Rich Turton 

# TODO:
- extend with MVVM layout using KVO.
- produce equivelant example in Swift. 


Many thanks to key collaborator Rogier Saarloos
