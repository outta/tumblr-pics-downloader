tumblr-pics-downloader
======================

It will download all the jpg, jpeg, png, gif files to your destination folder. 
It's very fast because of parallelization.

The downloader is based on the [David Shaw's Tumblr_scrape](https://github.com/davidshaw/Tumblr-Scrape).
Check his code out and compare to mine to see where the differences are.

Differences from the original version:
* the main difference: speed. I didn't measure the difference, but using 10 threads makes it approximately 8 times faster. Further increasing of threads didn't bring anything, but you can test it yourself.
* number of supported picture formats is also extended from |jpg and png| to |jpg, jpeg, png and gif|. 
One can add more formats easily by changing regexp in 2 places.
* code refactored a bit (if it became better or not is for you to judge)

## Example of usage:

go to the command prompt and type something like this:

    ruby tumblr_pics_downloader.rb http://best-of-tumblr.tumblr.com

Some of the things I am still going to change include:

* add other websites so that you can get pictures not only from tumblr, but let's say, also from [mmm-tasty.ru](http://mmm-tasty.ru).
If only I were a regexp pro it would be already done :)
* use [trollop](http://trollop.rubyforge.org) instead of parsing arguments manually (for such a simple script maybe there's no need, just wanna play with it a bit)
* save text if necessary *(still thinking if I will ever need it)*

If you like the idea and want me to further improve the code let me know by pressing the button.

[![endorse](https://api.coderwall.com/outta/endorsecount.png)](https://coderwall.com/outta)

Any suggestions are welcome.
