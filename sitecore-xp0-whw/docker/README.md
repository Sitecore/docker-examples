# Sitecore 10 XP0 Example using Windows Host Writer

An example repo for running Sitecore 10 XP0 with SPE topology on Docker. 

The build will layer in SPE. This exmaple uses the [Windows Host Writer](http://rockpapersitecore.com/2020/08/using-windows-hosts-writer-with-sitecore-10/) image to automatically update your `hosts` file for the running containers. The default host set in `.env` is `cm.konabos.local` which is different from the other examples.

Note that the override scales down the CD instance to 0 to save some CPU/RAM for local development purposes.
