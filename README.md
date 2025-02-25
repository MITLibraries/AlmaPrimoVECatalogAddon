# Alma Primo VE Catalog Search

## Versions

**1.0 -** Initial release, based on original Alma Primo Catalog Search addon

## Summary

The addon is located within an item record of an Atlas Product. It is found on the `"Catalog Search"` tab. The addon takes information from the fields in the Atlas Product and searches the catalog in the configured ordered. When the item is found, one selects the desired holding in the *Item Grid* below the browser and clicks *Import*. The addon then makes the necessary API calls to the Alma API and imports the item's information into the Atlas Product.

> **Note:** Only records with a valid MMS ID can be imported with this addon. An example of a record that may not have an MMS ID located within the Primo Page is a record coming from an online resource or external resource like HathiTrust.


## Settings

> **CatalogURL:** The base URL that the query strings are appended to. The Catalog URL structure is `{URL of the catalog}/primo-explore/`.
>
> **HomeURL:** Home page of the catalog. The Home URL structure is `{URL of the catalog}/primo-explore/search?vid={4 Digit Primo Code}`.
>
> **AutoSearch:** Defines whether the search should be automatically performed when the form opens.
>
>**RemoveTrailingSpecialCharacters:** Defines whether to remove trailing special characters on import or not. The included special characters are "` \/+,.;:-=.`".
>*Examples: `Baton Rouge, La.,` becomes `Baton Rouge, La.`*
>
>**AvailableSearchTypes:** The types of searches your catalog supports
>*Default: Title, Author*
>*Options: Title, Author, Call Number, Catalog Number, Subject, ISBN, ISSN*
>
>**SearchPriorityList:** The fields that should be searched on, in order of search priority. Each field in the string will be checked for a valid corresponding search value in the request, and the first search type with a valid corresponding value will be used. Each search type must be separated by a comma.
>*Default: Title, Author*
>
>**AutoRetrieveItems:** Defines whether or not the addon should automatically retrieve items related to a record being viewed. Disabling this setting can save the site on Alma API calls because it will only make a [Retrieve Holdings List](https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021om4RTvtjbPleCklCGxeYAfEqJOcQOaLEvEGUPgvJFpUQ==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e) call when the button is pressed.
>
>**AlmaAPIURL:** The URL to the Alma API. The API URL is generally the same between sites. (ex. `https://api-na.hosted.exlibrisgroup.com/almaws/v1/`) More information can be found on [Ex Libris' Site](https://developers.exlibrisgroup.com/alma/apis).
>
>**AlmaAPIKey:** API key used for interacting with the Alma API.
>
>**PrimoSiteCode:** The code that identifies the site in Primo Deep Links. Ex: vid={PrimoSiteCode}


## Buttons

The buttons for the Alma Primo Catalog Search addon are located in the *"Catalog Search"* ribbon in the top left of the requests.

>**Back:** Navigate back one page.
>
>**Forward:** Navigate forward one page.
>
>**Stop:** Stop loading the page.
>
>**Refresh:** Refresh the page.
>
>**New Search:** Goes to the home page of the catalog.
>
>**Search Button:** Performs the specified search on the catalog using the contents of the specified field.
>
>**Retrieve Items:** Retrieves the holding records for that item.
>*Note:* This button will not appear when AutoRetrieveItems is enabled.
>
>**Import:** Imports the selected record in the items grid.


## Data Mappings

Below are the default configurations for the catalog addon. The mappings within `DataMappings.lua` are settings that typically do not have to be modified from site to site. However, these data mappings can be changed to customize the fields, search queries, and xPath queries to the data.

>**Caution:** Be sure to backup the `DataMappings.lua` file before making modifications Incorrectly configured mappings may cause the addon to stop functioning correctly.

### MmsIdRegex
Defines the Regex pattern used to extract the MMS ID from the iFrame on item pages. This particular MMS ID entry is used because it was the most consistent across various Primo Webpages. To find the MMS ID, inspect the item page and search for `mmsId` and you will find the hidden input that the MMS ID is being extracted from.

### SearchTypes
The search URL is being constructed using the formula below.

*`{Catalog URL}`search?vid="`{Primo Site Code}`"&query="`{Search Type}`",contains,"`{Search Term}`"AND&search_scope=default_scope&mode=advanced*

*Default Configuration:*

| Search Type                               | Query String |
| ----------------------------------------- | ------------ |
| DataMapping.SearchTypes["Title"]          | `title`      |
| DataMapping.SearchTypes["Author"]         | `creator`    |
| DataMapping.SearchTypes["Call Number"]    | `lsr01`      |
| DataMapping.SearchTypes["Subject"]        | `sub`        |
| DataMapping.SearchTypes["ISBN"]           | `isbn`       |
| DataMapping.SearchTypes["ISSN"]           | `issn`       |
| DataMapping.SearchTypes["Catalog Number"] | `any`        |

>**Note:** The *Catalog Number* search type performs an `any` search because Primo does not have a search type for MMS ID.

### Source Fields
The field that the addon reads from to perform the search.

#### Aeon

*Default Configuration:*

| Field                                                 | Source Table  | Source Field        |
| ----------------------------------------------------- | ------------- | ------------------- |
| DataMapping.SourceFields["Aeon"]["Title"]             | `Transaction` | `ItemTitle`         |
| DataMapping.SourceFields["Aeon"]["Author"]            | `Transaction` | `ItemAuthor`        |
| DataMapping.SourceFields["Aeon"]["Call Number"]       | `Transaction` | `CallNumber`        |
| DataMapping.SourceFields["Aeon"]["Catalog Number"]    | `Transaction` | `ReferenceNumber`   |
| DataMapping.SourceFields["Aeon"]["Barcode"]           | `Transaction` | `ItemNumber`        |
| DataMapping.SourceFields["Aeon"]["TransactionNumber"] | `Transaction` | `TransactionNumber` |

### Bibliographic Import
The information within this data mapping is used to perform the bibliographic api call. The `Field` is the product field that the data will be imported into, `MaxSize` is the maximum character size the data going into the product field can be, and `Value` is the xPath query to the information.

>**Note:** Previously, the addon allowed one to specify multiple xPath queries for a single field by separating them with a comma. This prevented the use of Xpath expressions which contained commas, so the functionality was removed. Instead, one should use Xpath operators to specify multiple Xpath queries for a single field.

for example, to import subfields 'a' and 'b' from either the MARC 100, 110, or 111 use:

`//datafield[@tag='100' or @tag='110' or @tag='111']/subfield[@code='a' or @code='b']`.

If you expect more than one of the MARC fields in the Xpath expression could exist simultaneously, you can use '[1]' notation to select the first matching node.

`//datafield[@tag='100' or @tag='110' or @tag='111'][1]/subfield[@code='a' or @code='b']`

### Item Import
The information within this data mapping is used import the correct information from the items grid. The `Field` is the product field that the data will be imported into, `MaxSize` is the maximum character size the data going into the product field can be, and `Value` is the FieldName of the column within the item grid.

| Product Field   | Value           | Alma API XML Node | Description                                    |
| --------------- | --------------- | ----------------- | ---------------------------------------------- |
| ReferenceNumber | ReferenceNumber | mms_id            | The catalog identifier for the record (MMS ID) |
| CallNumber      | CallNumber      | call_number       | The item's call number                         |
| Location        | Location        | location          | The location of the item                       |
| Library         | Library         | library           | The library where the item is held             |
| ItemNumber      | Barcode         | barcode           | The item's barcode                             |

> **Note:** The Holding ID and Item Description can also be imported by adding another table with a Value of `HoldingId` and `Description`.


## Customized Mapping

The `CustomizedMapping.lua` file contains the mappings to variables that are more site specific.

### Location Mapping
Maps an item's location code to a full name. If a location mapping isn't given, the addon will display the location code. The location code is taken from the `location` node returned by a [Retrieve Items List](https://developers.exlibrisgroup.com/alma/apis/xsd/rest_items.xsd?tags=GET) API call.

```lua
CustomizedMapping.Locations["{Location Code }"] = "{Full Location Name}"
```


## FAQ

### How to add or change what information is displayed in the item grid?
There's more item information gathered than what is displayed in the item grid. If you wish to display or hide additional columns on the item grid, find the comment `-- Item Grid Column Settings` within the `BuildItemGrid()` function in the *Catalog.lua* file and change the `gridColumn.Visible` variable of the column you wish to modify.

### How to modify what bibliographic information is imported?
To import additional bibliographic fields, add another lua table to the `DataMapping.ImportFields.Bibliographic[{Product Name}]` mapping. To remove a record from the importing remove it from the lua table.

The table takes a `Table` and `Field` which correspond to a table and column name in the product, a `MaxSize` which is the maximum characters to be imported into the specified table column, and a `Value` which is the xPath query to the data returned by the [Retrieve Bibs](https://developers.exlibrisgroup.com/alma/apis/bibs/GET/gwPcGly021q2Z+qBbnVJzw==/af2fb69d-64f4-42bc-bb05-d8a0ae56936e) Alma API call.

### How to add a new Search Type?
There are search types baked into the addon that are not enabled by default. The available search types are listed below.

- Title
- Author
- Call Number
- Subject
- ISBN
- ISSN
- Catalog Number

To add these additional search types to your addon, open the addon's settings and find the `AvailableSearchTypes` setting. Add the Search Type's name to the comma-separated list within the value column. Save, refresh the cache, and reopen any item pages that may be open.

The new search type can be added to the addon's default configuration by opening the `Config.xml` document and find the `AvailableSearchTypes` setting. Add the Search Type's name to the comma-separated list within the value attribute of the setting. Save the document and reset the product's cache.

### How to add a custom Search Type?
**Note:** *Backup the addon before performing this customization. A misconfiguration may break the addon.*

First navigate to your primo catalog and go to the advanced search page. On the advanced search page, choose the search option that you wish to add. Search for anything using the chosen search option and look at the URL. Find the part that says `query={Search Type},`. Copy the search type (Example: *title, creator*).

Now that you have the search type, open up the DataMapping.lua file and scroll to the SearchTypes mapping. Copy and paste an existing SearchType mapping. Replace the string on the right side of the equals with your Search Type. Give the search type a name by replacing the string inside the brackets with the name of the search type. (Example: `DataMapping.SearchTypes["{Search Type Name}"] = "{searchType}";`).

Open up `Config.xml` and find *"AvailableSearchTypes"*. Add the *name* of the Search Type to the comma-separated list within the value attribute (be sure to add a comma between search types).

Finally, open Catalog.lua and find the commend that says `-- Search Functions`. Copy one of the search functions and paste it at the end of the search functions. Change the function's name to follow this formula; `Search{SearchTypeName}` (*Note: remove any spaces from the Search Type Name, but keep casing the same*). Within the PerformSearch method call, change the second parameter to be the Search Type Name (unmodified).


## Developers

The addon is developed to support Alma Catalogs that use PrimoVE as its discovery layer in [Aeon](https://www.atlas-sys.com/aeon/), [Ares](https://www.atlas-sys.com/ares), and [ILLiad](https://www.atlas-sys.com/illiad/).

Atlas welcomes developers to extend the addon with additional support. All pull requests will be merged and posted to the [addon directories](https://prometheus.atlas-sys.com/display/ILLiadAddons/Addon+Directory).

### Addon Files

* **Config.xml** - The addon configuration file.

* **DataMapping.lua** - The data mapping file contains mappings for the items that do not typically change from site to site.

* **CustomizedMapping.lua** - The a data mapping file that contains settings that are more site specific and likely to change (e.g. location codes).

* **Catalog.lua** - The Catalog.lua is the main file for the addon. It contains the main business logic for importing the data from the Alma API into the Atlas Product.

* **AlmaApi.lua** - The AlmaApi file is used to make the API calls against the Alma API.

* **Utility.lua** - The Utility file is used for common lua functions.

* **RegEx.lua** - Imports .NET's RegEx into lua.

* **WebClient.lua** - Used for making web client requests.
* 
