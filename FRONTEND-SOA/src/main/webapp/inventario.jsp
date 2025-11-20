<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inventario - Tienda Buena Lectura</title>
    <link href="styles/Catalogo.css?v=<%= System.currentTimeMillis()%>" rel="stylesheet">
</head>
<body>

    <% String rol = (String) session.getAttribute("rol"); %>

    <!-- ===== NAVBAR SUPERIOR ===== -->
    <div class="navbar">
        <h2>Tienda Buena Lectura</h2>

        <div class="nav-links">
            <a href="Inventario" class="active">📚 Inventario</a>
            <a href="Venta">💲 Ventas</a>

            <% if ("Administrador".equalsIgnoreCase(rol)) { %>
                <a href="Empleado">👥 Empleados</a>
                <a href="Reportes">📊 Reportes</a>
            <% } %>

            <a href="historial.jsp">🕓 Historial</a>
            <a href="Catalogo.jsp">📖 Catálogo</a>
            <a href="Login?accion=cerrar" class="logout">Salir</a>
        </div>
    </div>

    <!-- ===== CONTENIDO PRINCIPAL ===== -->
    <div class="main">
        <div class="contenedor">
            <h1>Inventario de Libros</h1>

            <div class="botones">
                <a href="Inventario" class="boton">📦 Listar Inventario</a>
                <a href="Inventario/Nuevo" class="boton">➕ Agregar Libro</a>
                <a href="Inventario/Buscar" class="boton">🔎 Buscar Libro</a>
            </div>

            <!-- Aquí puedes colocar la tabla del inventario -->
            <div class="tabla-section">
                <!-- Ejemplo temporal para mostrar la tabla del inventario -->
                <p style="text-align:center; margin-top:30px; color:#5A4635;">
                    Aquí aparecerá la tabla del inventario.
                </p>
            </div>

        </div>
    </div>

</body>
</html>
