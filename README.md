stacklead-node
==============

Short Node script, which can be pointed by Stacklead (stacklead.com) API to retrieve people's information by email from the webhook (https://stacklead.com/docs).

Two modes: test and real, to configure in `config.json`. Default to test.

In real mode, provide a valid API key in `config.json`, key `apiKey`.

To get the final CSV, visit the `/csv` URL. 
To get the RAW data, visit the `/raw` URL.

In test mode, it parses 10 times the sample `contact.json` provided file and output the same processed result as in real mode. Useful for debugging and fixing data structure.

To modify the output columns, modify the personTemplate in `config.json`