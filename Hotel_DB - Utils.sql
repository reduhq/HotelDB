USE Hotel_DB
GO

CREATE PROCEDURE generar_factura @id_reserva INT
AS
BEGIN
    SET NOCOUNT ON;
	
	-- Variables
	DECLARE @subtotal_habitaciones DECIMAL(10,2)
	DECLARE @subtotal_servicios DECIMAL(10,2)
	DECLARE @subtotal DECIMAL(10,2)
	DECLARE @total DECIMAL(10,2)

	-- Habitaciones
	SELECT @subtotal_habitaciones = SUM(precio)
	FROM Reserva_Habitacion
	WHERE id_reserva_habitacion = @id_reserva

	SELECT h.descripcion, rh.precio
	FROM Reserva_Habitacion rh JOIN Habitacion h ON rh.no_habitacion = h.no_habitacion
	WHERE id_reserva_habitacion = @id_reserva

	PRINT 'Subtotal Habitaciones: ' + CONVERT(VARCHAR, @subtotal_habitaciones)


	-- Reservas
	SELECT @subtotal_servicios = SUM(precio * cantidad)
	FROM Reserva_Habitacion_Servicio
	WHERE id_reserva_habitacion = @id_reserva

	SELECT s.descripcion, rhs.cantidad, rhs.precio, (rhs.cantidad * rhs.precio) subtotal
	FROM Reserva_Habitacion_Servicio rhs JOIN Servicio s ON rhs.no_servicio = s.no_servicio
	WHERE id_reserva_habitacion = @id_reserva

	PRINT 'Subtotal Servicios: ' + CONVERT(VARCHAR, @subtotal_servicios)


	-- Calcular total y subtotal
	SET @subtotal = @subtotal_habitaciones + @subtotal_servicios
	SET @total = @subtotal + (@subtotal*0.15)

	PRINT 'Subtotal: ' + CONVERT(VARCHAR, @subtotal)
	PRINT 'Subtotal+IVA(15%): ' + CONVERT(VARCHAR, @total)

	-- Insertando datos en la tabla factura
	INSERT INTO Factura(id_reserva, monto_habitaciones, monto_servicios, subtotal, subtotal_mas_IVA)
	VALUES (@id_reserva, @subtotal_habitaciones, @subtotal_servicios, @subtotal, @total)
END

CREATE PROCEDURE habitaciones_disponibles @fecha_entrada DATE, @fecha_salida DATE
AS
BEGIN
	SELECT th.tipo, COUNT(*) CantidadDisponible
	FROM Habitacion h JOIN Tipo_Habitacion th ON h.codigo_tipo_habitacion = th.codigo_tipo_habitacion
	WHERE h.codigo_tipo_habitacion NOT IN (
		SELECT h.codigo_tipo_habitacion
		FROM Habitacion h join Reserva_Habitacion rh ON h.no_habitacion = rh.no_habitacion
		WHERE (@fecha_entrada >= rh.fecha_entrada AND @fecha_entrada < rh.fecha_salida)
		   OR (@fecha_salida > rh.fecha_entrada AND @fecha_salida <= rh.fecha_salida)
		   OR (@fecha_entrada < rh.fecha_entrada AND @fecha_salida > rh.fecha_salida)
	)
	GROUP BY th.tipo
END

CREATE PROCEDURE recaudaciones_servicios @anio VARCHAR(4)
AS
BEGIN
	SELECT s.descripcion, MONTH(rh.fecha_entrada) Mes, SUM(rhs.cantidad) CantidadSolicitada
	FROM Reserva_Habitacion_Servicio rhs join Reserva_Habitacion rh ON rhs.id_reserva_habitacion = rh.id_reserva_habitacion
	JOIN Servicio s ON s.no_servicio = rhs.no_servicio
	WHERE YEAR(rh.fecha_entrada) = @anio
	GROUP BY s.descripcion, MONTH(rh.fecha_entrada)
END

CREATE TRIGGER factura_pagada
ON Factura
FOR INSERT
AS
BEGIN
	UPDATE Reserva
	SET estado = 'Pagado'
END