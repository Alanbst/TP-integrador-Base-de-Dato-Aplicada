-- =============================================
-- JUEGOS DE PRUEBA PARA LOS STORE PROCEDURES

-- Fecha de entrega: 23/05/25
-- Grupo N°13, Integrantes:
--      Bustamante Alan, 44793833
-- Base de Datos Aplicada
-- =============================================

USE Com3641G13;
GO

-- =============================================
-- Insertar adulto responsable
-- =============================================
EXEC procedimientos.InsertarAdultoResponsable
    @nombre = 'Carla',
    @apellido = 'Martínez',
    @dni = '22112233',
    @fecha_nacimiento = '1980-04-15',
    @email = 'carla.martinez@example.com',
    @telefono_contacto = '1122334455',
    @parentesco = 'Madre';
GO

-- =============================================
-- Insertar socio con adulto responsable
-- =============================================
EXEC procedimientos.InsertarSocio
    @nombre = 'Lucas',
    @apellido = 'Gómez',
    @dni = '44556677',
    @fecha_nacimiento = '2012-06-01',
    @email = 'lucas.gomez@example.com',
    @telefono_contacto = '1166778899',
    @telefono_emergencia = '1155667788',
    @obra_social = 'OSDE',
    @nro_socio_obra_social = 'OS123456',
    @categoria = 'Menor',
    @id_responsable = 2;
GO

-- =============================================
-- Insertar actividad
-- =============================================
EXEC procedimientos.InsertarActividad
    @nombre = 'Natación',
    @costo_mensual = 8000.00;
GO

-- =============================================
-- Inscribir socio a actividad
-- =============================================
EXEC procedimientos.InsertarInscripcion
    @id_socio = 1,
    @id_actividad = 1,
    @fecha_inscripcion = '2025-05-22';
GO

-- =============================================
-- Insertar factura
-- =============================================
EXEC procedimientos.InsertarFactura
    @id_socio = 1,
    @fecha_emision = '2025-05-22',
    @total = 8000.00,
    @estado = 'Emitida';
GO

-- =============================================
-- Insertar pago parcial
-- =============================================
EXEC procedimientos.InsertarPago
    @id_factura = 1,
    @fecha_pago = '2025-05-23',
    @medio_pago = 'Transferencia',
    @monto = 4000.00,
    @pago_a_cuenta = 0,
    @reintegro_lluvia = 0;
GO

-- =============================================
-- Insertar segundo pago para completar
-- =============================================
EXEC procedimientos.InsertarPago
    @id_factura = 1,
    @fecha_pago = '2025-05-24',
    @medio_pago = 'Efectivo',
    @monto = 4000.00,
    @pago_a_cuenta = 0,
    @reintegro_lluvia = 0;
GO

-- =============================================
-- Insertar pago con reintegro por lluvia
-- =============================================
EXEC procedimientos.InsertarPago
    @id_factura = 1,
    @fecha_pago = '2025-05-25',
    @medio_pago = 'Reintegro',
    @monto = -1000.00,
    @pago_a_cuenta = 0,
    @reintegro_lluvia = 1;
GO



-- =============================================
-- ACTUALIZAR actividad
-- =============================================
EXEC procedimientos.ModificarActividad
    @id_actividad = 1,
    @nombre = 'Natación Avanzada',
    @costo_mensual = 9000.00;
GO

-- =============================================
-- ACTUALIZAR socio
-- =============================================
EXEC procedimientos.ModificarSocio
    @id_socio = 1,
    @nombre = 'Lucas Martín',
    @apellido = 'Gómez',
    @dni = '44556677',
    @fecha_nacimiento = '2012-06-01',
    @email = 'lucasmgomez@example.com',
    @telefono_contacto = '1177998866',
    @telefono_emergencia = '1155667788',
    @obra_social = 'Swiss Medical',
    @nro_socio_obra_social = 'SM987654',
    @categoria = 'Cadete',
    @id_responsable = 1;
GO

-- =============================================
-- ACTUALIZAR factura (cambiar estado a Pagada)
-- =============================================
EXEC procedimientos.ModificarFactura
    @id_factura = 1,
    @id_socio = 1,
    @fecha_emision = '2025-05-22',
    @total = 8000.00,
    @estado = 'Pagada';
GO

-- =============================================
-- ELIMINAR inscripción (debe ser válida)
-- =============================================
EXEC procedimientos.BorrarInscripcion
    @id_inscripcion = 1;
GO

-- =============================================
-- ELIMINAR pagos (todos)
-- =============================================
EXEC procedimientos.BorrarPago @id_pago = 1;
GO
EXEC procedimientos.BorrarPago @id_pago = 2;
GO
EXEC procedimientos.BorrarPago @id_pago = 3;
GO

-- =============================================
-- ELIMINAR factura (después de eliminar pagos)
-- =============================================
EXEC procedimientos.BorrarFactura @id_factura = 1;
GO

-- =============================================
-- ELIMINAR socio (si no tiene inscripciones ni facturas)
-- =============================================
EXEC procedimientos.BorrarSocio @id_socio = 1;
GO

-- =============================================
-- ELIMINAR adulto responsable (si ya no hay socios menores asociados)
-- =============================================
EXEC procedimientos.BorrarAdultoResponsable @id_responsable = 1;
GO

-- =============================================
-- ELIMINAR actividad (si no hay inscripciones)
-- =============================================
EXEC procedimientos.BorrarActividad @id_actividad = 1;
GO

