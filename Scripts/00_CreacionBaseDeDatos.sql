-- ========================================================
-- SCRIPT DE CREACION DE BASE DE DATOS, ESQUEMAS Y TABLAS

-- Fecha de entrega: 23/05/25
-- Grupo N°13, Integrantes:
--      Bustamante Alan, 44793833
-- Base de Datos Aplicada
-- ========================================================

-- =======================
-- CREACION BASE DE DATOS
-- =======================
CREATE DATABASE Com3641G13;
GO

USE Com3641G13;
GO

-- =====================
-- CREACION DE ESQUEMAS
-- =====================
CREATE SCHEMA registro;
GO

CREATE SCHEMA administracion;
GO

CREATE SCHEMA actividades;
GO

CREATE SCHEMA procedimientos;
GO

-- ===================
-- CREACION DE TABLAS
-- ===================

-- Tabla ADULTO_RESP
CREATE TABLE registro.ADULTO_RESP (
    id_responsable INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    dni CHAR(8) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    email NVARCHAR(100),
    telefono_contacto NVARCHAR(20),
    parentesco NVARCHAR(30)
);
GO

-- Tabla SOCIO
CREATE TABLE registro.SOCIO (
    id_socio INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    dni CHAR(8) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    email NVARCHAR(100),
    telefono_contacto NVARCHAR(20),
    telefono_emergencia NVARCHAR(20),
    obra_social NVARCHAR(50),
    nro_socio_obra_social NVARCHAR(20),
    categoria NVARCHAR(10) NOT NULL CHECK (categoria IN ('Menor', 'Cadete', 'Mayor')),
    id_responsable INT NULL,
    CONSTRAINT FK_SOCIO_RESP FOREIGN KEY (id_responsable) REFERENCES registro.ADULTO_RESP(id_responsable)
);
GO

-- Tabla ACTIVIDAD
CREATE TABLE actividades.ACTIVIDAD (
    id_actividad INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL,
    costo_mensual DECIMAL(10,2) NOT NULL
);
GO

-- Tabla INSCRIPCION
CREATE TABLE registro.INSCRIPCION (
    id_inscripcion INT PRIMARY KEY IDENTITY(1,1),
    fecha_inscripcion DATE NOT NULL,
    id_socio INT NOT NULL,
    id_actividad INT NOT NULL,
    CONSTRAINT FK_INSCRIPCION_SOCIO FOREIGN KEY (id_socio) REFERENCES registro.SOCIO(id_socio),
    CONSTRAINT FK_INSCRIPCION_ACTIVIDAD FOREIGN KEY (id_actividad) REFERENCES actividades.ACTIVIDAD(id_actividad)
);
GO

-- Tabla FACTURA
CREATE TABLE administracion.FACTURA (
    id_factura INT PRIMARY KEY IDENTITY(1,1),
    fecha_emision DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado NVARCHAR(20) CHECK (estado IN ('Emitida', 'Parcial', 'Pagada')),
    id_socio INT NOT NULL,
    CONSTRAINT FK_FACTURA_SOCIO FOREIGN KEY (id_socio) REFERENCES registro.SOCIO(id_socio)
);
GO

-- Tabla PAGO
CREATE TABLE administracion.PAGO (
    id_pago INT PRIMARY KEY IDENTITY(1,1),
    fecha_pago DATE NOT NULL,
    medio_pago NVARCHAR(30),
    monto DECIMAL(10,2) NOT NULL,
    pago_a_cuenta BIT DEFAULT 0,
    reintegro_lluvia BIT DEFAULT 0,
    id_factura INT NOT NULL,
    CONSTRAINT FK_PAGO_FACTURA FOREIGN KEY (id_factura) REFERENCES administracion.FACTURA(id_factura)
);
GO

