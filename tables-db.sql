create table Product
(
    ProductID       int identity
        constraint PK_dbo_Product
            primary key,
    ProductSKU      nvarchar(50)   not null,
    ProductName     nvarchar(50)   not null,
    ProductCategory nvarchar(50)   not null,
    ItemGroup       nvarchar(50)   not null,
    KitType         nchar(3)       not null,
    Channels        tinyint        not null,
    Demographic     nvarchar(50)   not null,
    RetailPrice     money          not null,
    Photo           varbinary(max) not null
)
go

-- select distinct ItemGroup, KitType, Channels, Demographic from Product
-- select * from Product

create table Region
(
    RegionID   int identity
        constraint PK_dbo_Region
            primary key,
    RegionName nvarchar(50) not null
)
go

create table State
(
    StateID   int identity
        constraint PK_dbo_State
            primary key,
    StateCode nvarchar(2)  not null,
    StateName nvarchar(50) not null,
    TimeZone  nvarchar(10) not null,
    RegionID  int
        constraint FK_dbo_State_RegionID
            references Region
)
go

create table Sales
(
    OrderNumber     nchar(10)     not null
        constraint PK_dbo_Sales
            primary key,
    OrderDate       date          not null,
    ShipDate        date,
    CustomerStateID int           not null
        constraint FK_dbo_Sales_CustomerStateID
            references State,
    ProductID       int           not null
        constraint FK_dbo_Sales_ProductID
            references Product,
    Quantity        int           not null,
    UnitPrice       decimal(9, 2) not null,
    DiscountAmount  decimal(9, 2) not null,
    PromotionCode   nvarchar(20)
)
go

select * from Sales
--select PromotionCode from Sales where PromotionCode is not null

create table SalesOffice
(
    SalesOfficeID int identity
        constraint PK_dbo_SalesOffice
            primary key,
    AddressLine1  nvarchar(100) not null,
    AddressLine2  nvarchar(100) not null,
    City          nvarchar(50)  not null,
    StateID       int           not null
        constraint FK_dbo_SalesOffice_StateID
            references State,
    PostalCode    nchar(5)      not null,
    Telephone     nvarchar(20)  not null,
    Facsimile     nvarchar(20)  not null,
    Email         nvarchar(50)  not null
)
go

--select * from SalesOffice

create table zzVersion
(
    Version       varchar(20)   not null,
    VersionDate   smalldatetime not null,
    InstalledDate smalldatetime not null,
    Author        nvarchar(50)  not null,
    AuthorCompany nvarchar(50)  not null,
    AuthorEmail   nvarchar(50)  not null
)
go