This folder will contain the Solr cores (indexes) required by Sitecore.
If cores are added manually Sitecore will use them. Otherwise, Sitecore Docker images will add the default cores.
Please notice that Sitecore images will populate this folder with default indexes only if the folder has no cores (items which name starts with "sc_") or the file "solr.xml" is missing in the folder.
