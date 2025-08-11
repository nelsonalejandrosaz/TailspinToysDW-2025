-- Usar la base de datos TailspinToysDW
use TailspinToysDW;

-- Insertar datos en la dimensión Tiempo\
-- Eliminar datos existentes y resetear el identity
delete from DimTime;
DBCC CHECKIDENT ('DimTime', RESEED, 0);
-- Variables de rango de fechas
declare @FechaInicio date = '2020-01-01';
declare @FechaFin date = '2025-12-31';

while @FechaInicio <= @FechaFin
begin
    insert into DimTime (
        Date,
        Year,
        Month,
        Day,
        MouthName,
        DayName,
        Quarter,
        IsWeekend
    )
    values (
        @FechaInicio,
        year(@FechaInicio),
        month(@FechaInicio),
        day(@FechaInicio),
        datename(month, @FechaInicio),
        datename(weekday, @FechaInicio),
        datepart(quarter, @FechaInicio),
        IIF(datename(weekday, @FechaInicio) in (N'Saturday', N'Sunday'), 1, 0)
    );
    set @FechaInicio = dateadd(day, 1, @FechaInicio);
end

-- select * from DimTime;

-- Consulta para insertar datos en la tabla DimProducto
delete from DimProduct
DBCC CHECKIDENT ('DimProduct', RESEED, 0);

select
    p.ProductID,
    P.ProductSKU,
    P.ProductName,
    P.ProductCategory,
    P.RetailPrice
from [TailspinToys2020-US]..Product P;

-- Consuta para insertar datos en la tabla DimStateRegion
-- Eliminar datos existentes y resetear el identity
delete from DimStateRegion;
DBCC CHECKIDENT ('DimStateRegion', RESEED, 0);

-- Insertar datos en DimEstado desde la tabla fuente
select
    S.StateID,
    S.StateCode,
    S.StateName,
    S.TimeZone,
    S.RegionID,
    R.RegionName
from [TailspinToys2020-US]..State S
inner join [TailspinToys2020-US]..Region R on S.RegionID = R.RegionID

select * from [TailspinToys2020-US]..State
select * from [TailspinToys2020-US]..Region

-- Consulta para insertar datos en la tabla DimChunk
delete from DimChunk;
DBCC CHECKIDENT ('DimChunk', RESEED, 0);

select distinct
    P.ItemGroup,
    P.KitType,
    P.Channels,
    P.Demographic,
    -- Si PromotionCode es NULL, se inserta un valor por defecto 'NoCode'
    isnull(S.PromotionCode, 'NoCode') as PromotionCode
from [TailspinToys2020-US]..Product P
inner join [TailspinToys2020-US]..Sales S on P.ProductID = S.ProductID;

-- Consulta para insertar datos en la tabla FactSales
delete from FactSales;
DBCC CHECKIDENT ('FactSales', RESEED, 0);

insert into FactSales (
    ProductKey,
    StateRegionKey,
    TimeKey,
    ChunkKey,
    OrderNumber,
    Quantity,
    UnitPrice,
    DiscountAmount
)
select
    dp.ProductKey,
    dsr.StateRegionKey,
    dt.TimeKey,
    dc.ChunkKey,
    s.OrderNumber,
    s.Quantity,
    s.UnitPrice,
    s.DiscountAmount
from [TailspinToys2020-US]..Sales s
inner join DimProduct dp on s.ProductID = dp.ProductID
inner join DimStateRegion dsr on s.CustomerStateID = dsr.StateID
inner join DimTime dt on s.OrderDate = dt.Date
inner join [TailspinToys2020-US]..Product p on s.ProductID = p.ProductID
inner join DimChunk dc on
    dc.PromotionCode = isnull(s.PromotionCode, 'NoCode')
    and dc.Channels = p.Channels
    and dc.Demographic = p.Demographic
    and dc.KitType = p.KitType
    and dc.ItemGroup = p.ItemGroup
