# Auctionator

## [10.2.12](https://github.com/Auctionator/Auctionator/tree/10.2.12) (2024-01-05)
[Full Changelog](https://github.com/Auctionator/Auctionator/compare/10.2.11...10.2.12) 

- ResultsListing: Trucante header text when it is too long for the column width  
- Change tooltip text for edit item icon for a shopping list  
- Remove unused default toc file  
- [Fixes #1313] Resolve constant overflow/missing shopping lists  
    This was caused by doing full scans on a lot of different realms, this  
    should no longer cause data loss. Solution is to serialize the realm  
    data for any realms not currently in use.  
- Retail: Update color picker code for 10.2.5  
- Classic: Fix tooltip scan not always working when multiple done in sequence  
- Selling: Bag/Groups: Ensure favourites are always visible in the customise view  
