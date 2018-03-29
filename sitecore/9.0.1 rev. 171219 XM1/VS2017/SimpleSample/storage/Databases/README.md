This folder will contain the SQL databases required by Sitecore.
If databases are added manually Sitecore will use them. Otherwise, the Sitecore Docker image will add the default databases.
Please notice that Sitecore images will populate this folder with default databases only if the folder has no databases (files with "*.mdf" extension).