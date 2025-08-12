-- Crear la base de datos si no existe
if not exists (select * from sys.databases where name = 'TailspinToysDW')
begin
    create database TailspinToysDW;
end
-- Usar la base de datos TailspinToysDW
use TailspinToysDW;
-- Crear las tablas de dimensiones y hechos para el Data Warehouse de Tailspin Toys
-- Dimensión Producto
create table DimProduct (
    ProductKey int identity primary key,
    ProductID int,
    ProductSKU nvarchar(50),
    ProductName nvarchar(50),
    ProductCategory nvarchar(50),
    RetailPrice money,
    StartDate date,
    EndDate date,
    Active bit
);
go;
-- Dimensión Estado
create table DimStateRegion (
    StateRegionKey int identity primary key,
    StateID int,
    StateCode nvarchar(2),
    StateName nvarchar(50),
    TimeZone nvarchar(10),
    RegionID int,
    RegionName nvarchar(50),
    StartDate date,
    EndDate date,
    Active bit
);
go;

-- Dimensión Tiempo
create table DimTime (
    TimeKey int identity primary key,
    Date date,
    Year int,
    Quarter int,
    Month int,
    Day int,
    MouthName nvarchar(20),
    DayName nvarchar(20),
    IsWeekend bit,
    IsHoliday bit default 0
);
go;

-- Dimensión Basura (Chunk)
create table DimChunk (
    ChunkKey int identity primary key,
    PromotionCode nvarchar(20),
    Channels tinyint,
    Demographic nvarchar(50),
    KitType nchar(3),
    ItemGroup nvarchar(50)
);
go;
-- Tabla de hechos
create table FactSales (
    FactSalesKey int identity primary key,
    ProductKey int not null,
    StateRegionKey int not null,
    TimeKey int not null,
    ChunkKey int not null,
    OrderNumber nchar(10) not null,
    Quantity int,
    UnitPrice decimal(9,2),
    DiscountAmount decimal(9,2),
    foreign key (ProductKey) references DimProduct(ProductKey),
    foreign key (StateRegionKey) references DimStateRegion(StateRegionKey),
    foreign key (TimeKey) references DimTime(TimeKey),
    foreign key (ChunkKey) references DimChunk(ChunkKey)
);
go;

select * from DimProduct
select * from DimStateRegion
select * from DimTime
select * from DimChunk
select * from FactSales

truncate table FactSales