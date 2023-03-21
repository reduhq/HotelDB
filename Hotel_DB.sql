CREATE DATABASE Hotel_DB
GO 
USE Hotel_DB
GO 

-- Creacion de tablas

CREATE TABLE Tipo_Habitacion(
	codigo_tipo_habitacion INT PRIMARY KEY IDENTITY(1,1),
	tipo VARCHAR(50),
	precio MONEY
)

CREATE TABLE Habitacion(
	no_habitacion INT PRIMARY KEY IDENTITY(1,1),
	descripcion VARCHAR(50),
	capacidad INT,
	codigo_tipo_habitacion INT FOREIGN KEY REFERENCES Tipo_Habitacion(codigo_tipo_habitacion),
	estado VARCHAR(50)
)

CREATE TABLE Cliente(
	no_cliente INT PRIMARY KEY IDENTITY(1,1),
	nombres VARCHAR(50),
	apellidos VARCHAR(50),
	direccion VARCHAR(50),
	telefono VARCHAR(50),
	correo VARCHAR(50)
)

CREATE TABLE Empleado(
	no_empleado INT PRIMARY KEY IDENTITY(1,1),
	nombres VARCHAR(50),
	apellidos VARCHAR(50),
	direccion VARCHAR(50),
	telefono VARCHAR(50),
	correo VARCHAR(50)
)

CREATE TABLE Reserva(
	id_reserva INT PRIMARY KEY IDENTITY(1,1),
	fecha DATETIME,
	no_empleado INT FOREIGN KEY REFERENCES Empleado(no_empleado),
	no_cliente INT FOREIGN KEY REFERENCES Cliente(no_cliente),
	estado VARCHAR(50),
	forma_pago VARCHAR(50),
	pais VARCHAR(50),
	moneda VARCHAR(50)
)

CREATE TABLE Reserva_Habitacion(
	id_reserva_habitacion INT PRIMARY KEY IDENTITY(1,1),
	fecha_entrada DATETIME,
	fecha_salida DATETIME,
	no_habitacion INT FOREIGN KEY REFERENCES Habitacion(no_habitacion),
	id_reserva INT FOREIGN KEY REFERENCES Reserva(id_reserva),
	precio MONEY
)

CREATE TABLE Huesped(
	id_huesped INT PRIMARY KEY IDENTITY(1,1),
	nombres VARCHAR(50),
	apellidos VARCHAR(50),
	direccion VARCHAR(50),
	telefono VARCHAR(50),
	correo VARCHAR(50)
)

CREATE TABLE Reserva_Habitacion_huesped(
	id_huesped INT FOREIGN KEY REFERENCES Huesped(id_huesped),
	id_reserva_habitacion INT FOREIGN KEY REFERENCES Reserva_Habitacion(id_reserva_habitacion),
)

CREATE TABLE Servicio(
	no_servicio INT PRIMARY KEY IDENTITY(1,1),
	descripcion VARCHAR(50),
	precio MONEY
)

CREATE TABLE Reserva_Habitacion_Servicio(
	no_servicio INT FOREIGN KEY REFERENCES Servicio(no_servicio),
	id_reserva_habitacion INT FOREIGN KEY REFERENCES Reserva_Habitacion(id_reserva_habitacion),
	cantidad INT,
	precio MONEY
)

CREATE TABLE Factura(
	id_factura INT PRIMARY KEY IDENTITY(1,1),
	id_reserva INT FOREIGN KEY REFERENCES Reserva_Habitacion(id_reserva_habitacion),
	monto_habitaciones MONEY,
	monto_servicios MONEY,
	subtotal MONEY,
	subtotal_mas_IVA MONEY
)

-- Ingresando datos de prueba

-- Registros para Servicio
INSERT INTO Servicio (descripcion, precio)
VALUES ('Servicio de habitación', 25.50),
       ('Desayuno continental', 12.75),
       ('Almuerzo buffet', 28.00),
       ('Cena gourmet', 45.00),
       ('Servicio de lavandería', 15.00),
       ('Servicio de limpieza', 20.00),
       ('Internet de alta velocidad', 10.50),
       ('Servicio de masajes', 75.00),
       ('Traslado al aeropuerto', 50.00),
       ('Servicio de niñera', 35.00);

-- Registros para Tipo_Habitacion
INSERT INTO Tipo_Habitacion(tipo, precio)
VALUES ('Basica', 150.00),
	   ('Ejecutiva', 200.00),
	   ('Presidencial', 500.00)

-- Registros para Habitacion
INSERT INTO Habitacion (descripcion, capacidad, codigo_tipo_habitacion, estado)
VALUES ('Habitación sencilla', 1, 1, 'Disponible'),
       ('Habitación doble', 2, 2, 'Disponible'),
       ('Habitación de lujo', 3, 3, 'Ocupada'),
       ('Habitación familiar', 4, 1, 'Disponible');

-- Registros para Cliente .......
INSERT INTO Cliente (nombres, apellidos, direccion, telefono, correo)
VALUES ('Juan', 'Pérez', 'Av. Siempre Viva 123', '12345678', 'juanperez@mail.com'),
       ('María', 'González', 'Calle Falsa 123', '87654321', 'mariagonzalez@mail.com'),
       ('Pedro', 'Gómez', 'Av. Principal 456', '45678901', 'pedrogomez@mail.com');

-- Registros para Empleado
INSERT INTO Empleado (nombres, apellidos, direccion, telefono, correo)
VALUES ('Luis', 'Martínez', 'Av. Principal 456', '45678901', 'luismartinez@mail.com'),
       ('Ana', 'García', 'Calle Falsa 123', '87654321', 'anagarcia@mail.com'),
       ('Juan', 'Pérez', 'Av. Siempre Viva 123', '12345678', 'juanperez@mail.com');

-- Registros para Reserva
INSERT INTO Reserva (fecha, no_empleado, no_cliente, estado, forma_pago, pais, moneda)
VALUES ('2023-03-22 10:00:00', 1, 1, 'Reservado', 'Tarjeta', 'México', 'MXN'),
       ('2023-03-23 15:00:00', 2, 2, 'Pagado', 'Contado', 'Estados Unidos', 'USD'),
       ('2023-03-25 12:00:00', 3, 3, 'Cancelado', 'Contado', 'Canadá', 'CAD');

-- Registros para Reserva_Habitacion
INSERT INTO Reserva_Habitacion (fecha_entrada, fecha_salida, no_habitacion, id_reserva, precio)
VALUES ('2023-03-22 12:00:00', '2023-03-24 12:00:00', 1, 1, (SELECT precio FROM Habitacion h join Tipo_Habitacion th ON h.codigo_tipo_habitacion = th.codigo_tipo_habitacion WHERE h.no_habitacion = 1)),
       ('2023-03-23 12:00:00', '2023-03-27 12:00:00', 2, 2, (SELECT precio FROM Habitacion h join Tipo_Habitacion th ON h.codigo_tipo_habitacion = th.codigo_tipo_habitacion WHERE h.no_habitacion = 2)),
       ('2023-03-25 12:00:00', '2023-03-27 12:00:00', 3, 3, (SELECT precio FROM Habitacion h join Tipo_Habitacion th ON h.codigo_tipo_habitacion = th.codigo_tipo_habitacion WHERE h.no_habitacion = 3));

-- Registros para Huesped
INSERT INTO Huesped(nombres, apellidos, direccion, telefono, correo) 
VALUES ('Juan', 'Pérez', 'Calle 1 #123', '555-1234', 'juan.perez@gmail.com'),
       ('María', 'González', 'Calle 2 #456', '555-5678', 'maria.gonzalez@gmail.com'),
       ('Pedro', 'Rodríguez', 'Calle 3 #789', '555-9012', 'pedro.rodriguez@gmail.com')

-- Registros para Reserva_Habitacion_huesped
INSERT INTO Reserva_Habitacion_huesped(id_huesped, id_reserva_habitacion)
VALUES (1, 1),
	   (2, 1),
	   (3, 1),
	   (1, 2),
	   (2, 2),
	   (1, 3)

-- Datos de prueba para la tabla Reserva_Habitacion_Servicio
INSERT INTO Reserva_Habitacion_Servicio(no_servicio, id_reserva_habitacion, cantidad, precio)
VALUES (1, 1, 2, (SELECT precio FROM Servicio WHERE no_servicio = 1)),
	   (2, 1, 1, (SELECT precio FROM Servicio WHERE no_servicio = 2)),
	   (1, 2, 1, (SELECT precio FROM Servicio WHERE no_servicio = 1)),
	   (3, 2, 3, (SELECT precio FROM Servicio WHERE no_servicio = 3)),
	   (2, 3, 2, (SELECT precio FROM Servicio WHERE no_servicio = 2)),
	   (3, 3, 1, (SELECT precio FROM Servicio WHERE no_servicio = 3))