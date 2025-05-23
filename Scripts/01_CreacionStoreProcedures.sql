-- =============================================
-- SCRIPT DE CREACION DE STORE PROCEDURES

-- Fecha de entrega: 23/05/25
-- Grupo N°13, Integrantes:
--      Bustamante Alan, 44793833
-- Base de Datos Aplicada
-- =============================================

USE Com3641G13;
GO

-- =============================================
-- SP: SOCIO
-- =============================================

-- INSERTAR SOCIO
CREATE PROCEDURE procedimientos.InsertarSocio
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @dni CHAR(8),
    @fecha_nacimiento DATE,
    @email NVARCHAR(100),
    @telefono_contacto NVARCHAR(20),
    @telefono_emergencia NVARCHAR(20),
    @obra_social NVARCHAR(50),
    @nro_socio_obra_social NVARCHAR(20),
    @categoria NVARCHAR(10),
    @id_responsable INT = NULL
AS
BEGIN

    IF EXISTS ( SELECT 1 FROM registro.SOCIO WHERE dni = @dni)
    BEGIN
        PRINT 'Ya existe un socio con ese DNI.';
        RETURN;
    END
    
    INSERT INTO registro.SOCIO (
        nombre, apellido, dni, fecha_nacimiento, email, telefono_contacto, 
        telefono_emergencia, obra_social, nro_socio_obra_social, categoria, id_responsable
    )
    VALUES (
        @nombre, @apellido, @dni, @fecha_nacimiento, @email, @telefono_contacto, 
        @telefono_emergencia, @obra_social, @nro_socio_obra_social, @categoria, @id_responsable
    );
    PRINT 'Socio insertado correctamente.';

END;
GO

----------------------------------------------------
-- MODIFICAR SOCIO
CREATE PROCEDURE procedimientos.ModificarSocio
    @id_socio INT,
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @dni CHAR(8),
    @fecha_nacimiento DATE,
    @email NVARCHAR(100),
    @telefono_contacto NVARCHAR(20),
    @telefono_emergencia NVARCHAR(20),
    @obra_social NVARCHAR(50),
    @nro_socio_obra_social NVARCHAR(20),
    @categoria NVARCHAR(10),
    @id_responsable INT = NULL
AS
BEGIN

    IF NOT EXISTS ( SELECT 1 FROM registro.SOCIO WHERE id_socio = @id_socio)
    BEGIN
        PRINT 'No existe un socio con el ID indicado.';
        RETURN;
    END

    IF EXISTS ( 
        SELECT 1 FROM registro.SOCIO
        WHERE dni = @dni AND id_socio <> @id_socio
    )
    BEGIN
        PRINT 'El DNI ingresado ya pertenece a otro socio.';
        RETURN;
    END

UPDATE registro.SOCIO
    SET
        nombre = @nombre,
        apellido = @apellido,
        dni = @dni,
        fecha_nacimiento = @fecha_nacimiento,
        email = @email,
        telefono_contacto = @telefono_contacto,
        telefono_emergencia = @telefono_emergencia,
        obra_social = @obra_social,
        nro_socio_obra_social = @nro_socio_obra_social,
        categoria = @categoria,
        id_responsable = @id_responsable
    WHERE id_socio = @id_socio;

    PRINT 'Socio actualizado correctamente.';
END;
GO

----------------------------------------------------
-- BORRAR SOCIO
CREATE PROCEDURE procedimientos.BorrarSocio
    @id_socio INT
AS
BEGIN

    IF EXISTS (
        SELECT 1 FROM registro.INSCRIPCION WHERE id_socio = @id_socio
    )
    BEGIN
        PRINT 'No se puede eliminar el socio: tiene inscripciones registradas.';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM administracion.FACTURA WHERE id_socio = @id_socio
    )
    BEGIN
        PRINT 'No se puede eliminar el socio: tiene facturas asociadas.';
        RETURN;
    END

    DELETE FROM registro.SOCIO
    WHERE id_socio = @id_socio;

    PRINT 'Socio eliminado correctamente.';

END;
GO


-- =============================================
-- SP: ADULTO_RESP
-- =============================================

-- INSERTAR ADULTO RESPONSABLE
CREATE PROCEDURE Procedimientos.InsertarAdultoResponsable
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @dni CHAR(8),
    @fecha_nacimiento DATE,
    @email NVARCHAR(100),
    @telefono_contacto NVARCHAR(20),
    @parentesco NVARCHAR(30)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM registro.ADULTO_RESP WHERE dni = @dni)
    BEGIN
        PRINT 'Ya existe un adulto responsable con ese DNI.';
        RETURN;
    END

    INSERT INTO registro.ADULTO_RESP (
        nombre, apellido, dni, fecha_nacimiento,
        email, telefono_contacto, parentesco
    )
    VALUES (
        @nombre, @apellido, @dni, @fecha_nacimiento,
        @email, @telefono_contacto, @parentesco
    );

    PRINT 'Adulto responsable insertado correctamente.';
END;
GO

----------------------------------------------------
-- MODIFICAR ADULTO RESPONSABLE
CREATE PROCEDURE procedimientos.ModificarAdultoResponsable
    @id_responsable INT,
    @nombre NVARCHAR(50),
    @apellido NVARCHAR(50),
    @dni CHAR(8),
    @fecha_nacimiento DATE,
    @email NVARCHAR(100),
    @telefono_contacto NVARCHAR(20),
    @parentesco NVARCHAR(30)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM registro.ADULTO_RESP WHERE id_responsable = @id_responsable)
    BEGIN
        PRINT 'No existe un adulto responsable con el ID indicado.';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM registro.ADULTO_RESP
        WHERE dni = @dni AND id_responsable <> @id_responsable
    )
    BEGIN
        PRINT 'El DNI ingresado ya pertenece a otro adulto responsable.';
        RETURN;
    END

    UPDATE registro.ADULTO_RESP
    SET
        nombre = @nombre,
        apellido = @apellido,
        dni = @dni,
        fecha_nacimiento = @fecha_nacimiento,
        email = @email,
        telefono_contacto = @telefono_contacto,
        parentesco = @parentesco
    WHERE id_responsable = @id_responsable;

    PRINT 'Adulto responsable actualizado correctamente.';
END;
GO

----------------------------------------------------
-- BORRAR ADULTO RESPONSABLE
CREATE PROCEDURE procedimientos.BorrarAdultoResponsable
    @id_responsable INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM registro.SOCIO WHERE id_responsable = @id_responsable
    )
    BEGIN
        PRINT 'No se puede eliminar el adulto responsable: está asociado a uno o más socios.';
        RETURN;
    END

    DELETE FROM registro.ADULTO_RESP WHERE id_responsable = @id_responsable;

    PRINT 'Adulto responsable eliminado correctamente.';
END;
GO


-- =============================================
-- SP: ACTIVIDAD
-- =============================================

-- INSERTAR ACTIVIDAD
CREATE PROCEDURE procedimientos.InsertarActividad
    @nombre NVARCHAR(50),
    @costo_mensual DECIMAL(10,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM actividades.ACTIVIDAD WHERE nombre = @nombre)
    BEGIN
        PRINT 'Ya existe una actividad con ese nombre.';
        RETURN;
    END

    INSERT INTO actividades.ACTIVIDAD (nombre, costo_mensual)
    VALUES (@nombre, @costo_mensual);

    PRINT 'Actividad insertada correctamente.';
END;
GO

----------------------------------------------------
-- MODIFICAR ACTIVIDAD
CREATE PROCEDURE procedimientos.ModificarActividad
    @id_actividad INT,
    @nombre NVARCHAR(50),
    @costo_mensual DECIMAL(10,2)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM actividades.ACTIVIDAD WHERE id_actividad = @id_actividad)
    BEGIN
        PRINT 'No existe una actividad con ese ID.';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM actividades.ACTIVIDAD
        WHERE nombre = @nombre AND id_actividad <> @id_actividad
    )
    BEGIN
        PRINT 'Ese nombre ya pertenece a otra actividad.';
        RETURN;
    END

    UPDATE actividades.ACTIVIDAD
    SET nombre = @nombre,
        costo_mensual = @costo_mensual
    WHERE id_actividad = @id_actividad;

    PRINT 'Actividad modificada correctamente.';
END;
GO

----------------------------------------------------
-- BORRAR ACTIVIDAD
CREATE PROCEDURE procedimientos.BorrarActividad
    @id_actividad INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM registro.INSCRIPCION WHERE id_actividad = @id_actividad
    )
    BEGIN
        PRINT 'No se puede eliminar la actividad: tiene inscripciones asociadas.';
        RETURN;
    END

    DELETE FROM actividades.ACTIVIDAD WHERE id_actividad = @id_actividad;

    PRINT 'Actividad eliminada correctamente.';
END;
GO


-- =============================================
-- SP: INSCRIPCION
-- =============================================

-- INSERTAR INSCRIPCION
CREATE PROCEDURE procedimientos.InsertarInscripcion
    @id_socio INT,
    @id_actividad INT,
    @fecha_inscripcion DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM registro.SOCIO WHERE id_socio = @id_socio)
    BEGIN
        PRINT 'No existe un socio con el ID proporcionado.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM actividades.ACTIVIDAD WHERE id_actividad = @id_actividad)
    BEGIN
        PRINT 'No existe una actividad con el ID proporcionado.';
        RETURN;
    END

    IF EXISTS (
        SELECT 1 FROM registro.INSCRIPCION
        WHERE id_socio = @id_socio AND id_actividad = @id_actividad
    )
    BEGIN
        PRINT 'El socio ya está inscripto en esa actividad.';
        RETURN;
    END

    INSERT INTO registro.INSCRIPCION (id_socio, id_actividad, fecha_inscripcion)
    VALUES (@id_socio, @id_actividad, @fecha_inscripcion);

    PRINT 'Inscripción registrada correctamente.';
END;
GO

----------------------------------------------------
-- MODIFICAR INSCRIPCION
CREATE PROCEDURE procedimientos.ModificarInscripcion
    @id_inscripcion INT,
    @id_socio INT,
    @id_actividad INT,
    @fecha_inscripcion DATE
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM registro.INSCRIPCION WHERE id_inscripcion = @id_inscripcion)
    BEGIN
        PRINT 'No existe una inscripción con ese ID.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM registro.SOCIO WHERE id_socio = @id_socio)
    BEGIN
        PRINT 'No existe un socio con el ID proporcionado.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM actividades.ACTIVIDAD WHERE id_actividad = @id_actividad)
    BEGIN
        PRINT 'No existe una actividad con el ID proporcionado.';
        RETURN;
    END

    UPDATE registro.INSCRIPCION
    SET id_socio = @id_socio,
        id_actividad = @id_actividad,
        fecha_inscripcion = @fecha_inscripcion
    WHERE id_inscripcion = @id_inscripcion;

    PRINT 'Inscripción actualizada correctamente.';
END;
GO

----------------------------------------------------
-- BORRAR INSCRIPCION
CREATE PROCEDURE procedimientos.BorrarInscripcion
    @id_inscripcion INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM registro.INSCRIPCION WHERE id_inscripcion = @id_inscripcion)
    BEGIN
        PRINT 'No existe una inscripción con el ID proporcionado.';
        RETURN;
    END

    DELETE FROM registro.INSCRIPCION WHERE id_inscripcion = @id_inscripcion;

    PRINT 'Inscripción eliminada correctamente.';
END;
GO


-- =============================================
-- SP: FACTURA
-- =============================================

-- INSERTAR FACTURA
CREATE PROCEDURE procedimientos.InsertarFactura
    @id_socio INT,
    @fecha_emision DATE,
    @total DECIMAL(10,2),
    @estado NVARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM registro.SOCIO WHERE id_socio = @id_socio)
    BEGIN
        PRINT 'No existe un socio con el ID proporcionado.';
        RETURN;
    END

    IF @estado NOT IN ('Emitida', 'Parcial', 'Pagada')
    BEGIN
        PRINT 'Estado de factura no válido.';
        RETURN;
    END

    INSERT INTO administracion.FACTURA (id_socio, fecha_emision, total, estado)
    VALUES (@id_socio, @fecha_emision, @total, @estado);

    PRINT 'Factura insertada correctamente.';
END;
GO

----------------------------------------------------
-- MODIFICAR FACTURA
CREATE PROCEDURE procedimientos.ModificarFactura
    @id_factura INT,
    @id_socio INT,
    @fecha_emision DATE,
    @total DECIMAL(10,2),
    @estado NVARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM administracion.FACTURA WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'No existe una factura con ese ID.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM registro.SOCIO WHERE id_socio = @id_socio)
    BEGIN
        PRINT 'No existe un socio con el ID proporcionado.';
        RETURN;
    END

    IF @estado NOT IN ('Emitida', 'Parcial', 'Pagada')
    BEGIN
        PRINT 'Estado de factura no válido.';
        RETURN;
    END

    UPDATE administracion.FACTURA
    SET id_socio = @id_socio,
        fecha_emision = @fecha_emision,
        total = @total,
        estado = @estado
    WHERE id_factura = @id_factura;

    PRINT 'Factura actualizada correctamente.';
END;
GO

----------------------------------------------------
-- BORRAR FACTURA
CREATE PROCEDURE procedimientos.BorrarFactura
    @id_factura INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM administracion.FACTURA WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'No existe una factura con el ID proporcionado.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM administracion.PAGO WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'No se puede eliminar la factura: tiene pagos asociados.';
        RETURN;
    END

    DELETE FROM administracion.FACTURA WHERE id_factura = @id_factura;

    PRINT 'Factura eliminada correctamente.';
END;
GO


-- =============================================
-- SP: PAGO
-- =============================================

-- INSERTAR PAGO
CREATE PROCEDURE procedimientos.InsertarPago
    @id_factura INT,
    @fecha_pago DATE,
    @medio_pago NVARCHAR(30),
    @monto DECIMAL(10,2),
    @pago_a_cuenta BIT = 0,
    @reintegro_lluvia BIT = 0
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM administracion.FACTURA WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'No existe una factura con el ID proporcionado.';
        RETURN;
    END

    INSERT INTO administracion.PAGO (
        id_factura, fecha_pago, medio_pago,
        monto, pago_a_cuenta, reintegro_lluvia
    )
    VALUES (
        @id_factura, @fecha_pago, @medio_pago,
        @monto, @pago_a_cuenta, @reintegro_lluvia
    );

    PRINT 'Pago registrado correctamente.';
END;
GO

----------------------------------------------------
-- MODIFICAR PAGO
CREATE PROCEDURE procedimientos.ModificarPago
    @id_pago INT,
    @id_factura INT,
    @fecha_pago DATE,
    @medio_pago NVARCHAR(30),
    @monto DECIMAL(10,2),
    @pago_a_cuenta BIT = 0,
    @reintegro_lluvia BIT = 0
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM administracion.PAGO WHERE id_pago = @id_pago)
    BEGIN
        PRINT 'No existe un pago con el ID indicado.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM administracion.FACTURA WHERE id_factura = @id_factura)
    BEGIN
        PRINT 'No existe una factura con el ID proporcionado.';
        RETURN;
    END

    UPDATE administracion.PAGO
    SET
        id_factura = @id_factura,
        fecha_pago = @fecha_pago,
        medio_pago = @medio_pago,
        monto = @monto,
        pago_a_cuenta = @pago_a_cuenta,
        reintegro_lluvia = @reintegro_lluvia
    WHERE id_pago = @id_pago;

    PRINT 'Pago actualizado correctamente.';
END;
GO

----------------------------------------------------
-- BORRAR PAGO
CREATE PROCEDURE procedimientos.BorrarPago
    @id_pago INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM administracion.PAGO WHERE id_pago = @id_pago)
    BEGIN
        PRINT 'No existe un pago con el ID proporcionado.';
        RETURN;
    END

    DELETE FROM administracion.PAGO WHERE id_pago = @id_pago;

    PRINT 'Pago eliminado correctamente.';
END;
GO

