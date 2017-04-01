#! /usr/bin/env python3
# -*- coding: utf-8; mode: python -*-
""" A small scrapper (using Scrapy) to extract URL of some songs in my YouTube "Watch Later" playlist.

- *Date:* 22/02/2017.
- *Author:* Lilian Besson © 2017.
- *Licence:* MIT Licence (http://lbesson.mit-license.org).
"""

from __future__ import print_function  # Python 2 compatibility if needed
import scrapy


class QuotesSpider(scrapy.Spider):
    name = "Watch Later"
    start_urls = [
        'file:///tmp/wl.html'
    ]

    def parse(self, response):
        print("response =", response)  # DEBUG
        i = 0
        for item in response.css('td.pl-video-title'):
            print("i =", i)  # DEBUG
            print("item =", item)  # DEBUG
            i += 1
            video = item.css('a.pl-video-title-link')[0]
            author = item.css('div.pl-video-owner')[0]
            yield {
                'id': i,
                'href': video.xpath('@href').extract_first().replace('&index=%i&list=WL'%i, ''),
                'title': video.css('a::text').extract_first().strip(),
                'author': author.css('a::text').extract_first().strip()
            }


# End of youtube_playlist_spider_scrapy.py
