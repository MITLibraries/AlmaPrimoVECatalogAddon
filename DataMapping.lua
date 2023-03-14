DataMapping = {}
DataMapping.Icons = {};
DataMapping.SearchTypes = {};
DataMapping.SourceFields = {};
DataMapping.ImportFields = {};
DataMapping.ImportFields.Bibliographic = {};
DataMapping.ImportFields.Item = {};
DataMapping.ImportFields.StaticHolding = {};

--Typical Settings that shouldn't need user configuration
DataMapping.LabelName = "Catalog Search";
DataMapping.MmsIdRegex = '(?s)name="mmsId"[^>]*value="(?<mmsId>\\d*)';

-- Icons: Aeon
DataMapping.Icons["Aeon"] = {};
DataMapping.Icons["Aeon"]["Search"] = "srch_32x32";
DataMapping.Icons["Aeon"]["Home"] = "home_32x32";
DataMapping.Icons["Aeon"]["Web"] = "web_32x32";
DataMapping.Icons["Aeon"]["Record"] = "record_32x32";
DataMapping.Icons["Aeon"]["Import"] = "impt_32x32";

-- SearchTypes
DataMapping.SearchTypes["Title"] = "title";
DataMapping.SearchTypes["Author"] = "creator";
DataMapping.SearchTypes["Call Number"] = "lsr01";
DataMapping.SearchTypes["Subject"] = "sub";
DataMapping.SearchTypes["ISBN"] = "isbn";
DataMapping.SearchTypes["ISSN"] = "issn";

-- Catalog Number uses the Any search type because 
-- Primo catalogs don't have built in MMS ID searching
DataMapping.SearchTypes["Catalog Number"] = "any";

-- Source Fields: Aeon
DataMapping.SourceFields["Aeon"] = {};
DataMapping.SourceFields["Aeon"]["Title"] = { Table = "Transaction", Field = "ItemTitle" };
DataMapping.SourceFields["Aeon"]["Author"] = { Table = "Transaction", Field = "ItemAuthor" };
DataMapping.SourceFields["Aeon"]["Call Number"] = { Table = "Transaction", Field = "CallNumber" };
DataMapping.SourceFields["Aeon"]["Catalog Number"] = { Table = "Transaction", Field = "ReferenceNumber" };
DataMapping.SourceFields["Aeon"]["TransactionNumber"] = { Table = "Transaction", Field = "TransactionNumber" };

-- Import Fields
DataMapping.ImportFields.Bibliographic["Aeon"] = {
    {
        Table = "Transaction",
        Field = "ItemTitle", MaxSize = 255,
        Value = "//datafield[@tag='245']/subfield[@code='a']|//datafield[@tag='245']/subfield[@code='b']"
    },
    {
        Table = "Transaction",
        Field = "ItemAuthor", MaxSize = 255,
        Value = "//datafield[@tag='100' or @tag='110' or @tag='111']/subfield[@code='a' or @code='b']"
    },
    {
        Table = "Transaction",
        Field ="ItemDate", MaxSize = 50,
        Value = "//datafield[@tag='260']/subfield[@code='c']|//datafield[@tag='264']/subfield[@code='c']"
    },
    {
        Table = "Transaction",
        Field ="ItemEdition", MaxSize = 50,
        Value = "//datafield[@tag='300']"
    },
    {
-- notes and boundwith information 
        Table = "Transaction",
        Field ="ItemSubTitle", MaxSize = 255,
        Value = "//datafield[@tag='990']|//datafield[@tag='992']|//datafield[@tag='993']"
    },
    {
-- Volume/box - shirea 5/2021
        Table = "Transaction",
        Field ="ItemVolume", MaxSize = 255,
        Value = "//datafield[@tag='988']/subfield[@code='p']|//datafield[@tag='988']/subfield[@code='b']"
    },
    {
-- Series - shirea 5/2021
        Table = "Transaction.CustomFields",
        Field ="SeriesNumber", MaxSize = 255,
        Value = "//datafield[@tag='830']"
    },
-- OCLC Number
    {
        Table = "Transaction.CustomFields",
        Field = "OCLCNum", MaxSize = 255,
        Value = "//datafield[@tag='035'][subfield[text()[contains(.,'(OCoLC)')]]][1]"
    },
-- DSpace URL
    {
        Table = "Transaction.CustomFields",
        Field = "DspaceURL", MaxSize = 255,
        Value = "//datafield[@tag='856'][subfield[text()[contains(.,'DSpace@MIT')]]]/subfield[@code='u']"
    }

};


DataMapping.ImportFields.Item["Aeon"] = {
    {
        Table = "Transaction",
        Field = "ReferenceNumber", MaxSize = 50,
        Value = "ReferenceNumber"
    },
    {
        Table = "Transaction",
        Field = "CallNumber", MaxSize = 255,
        Value = "CallNumber"
    },
    {
        Table = "Transaction",
        Field = "ItemNumber", MaxSize = 255,
        Value = "Barcode"
    },
    {
        Table = "Transaction",
        Field = "Location", MaxSize = 255,
        Value = "Location"
    },
    {
        Table = "Transaction.CustomFields",
        Field = "Issue", MaxSize = 255,
        Value = "Description"
    }
};