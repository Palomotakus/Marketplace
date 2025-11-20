<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Catálogo de Libros</title>
    <link href="styles/Catalogo.css?v=<%= System.currentTimeMillis()%>" rel="stylesheet">
</head>
<body>

    <%
        String rol = (String) session.getAttribute("rol");
    %>

    <!-- ===== NAVBAR SUPERIOR ===== -->
    <div class="navbar">
        <h2>Tienda Buena Lectura</h2>

        <div class="nav-links">
            <a href="Inventario">Inventario</a>
            <a href="Venta">Ventas</a>

            <% if ("Administrador".equalsIgnoreCase(rol)) { %>
                <a href="Empleado">Empleados</a>
                <a href="Reportes">Reportes</a>
            <% } %>

            <a href="historial.jsp">Historial</a>
            <a href="Catalogo.jsp" class="active">Catálogo</a>
            <a href="Login?accion=cerrar" class="logout">Salir</a>
        </div>
    </div>

    <!-- ===== CONTENIDO ===== -->
    <div class="main">
        <div class="contenedor">
            <h1>Catálogo de Libros</h1>

            <a href="Catalogo/" class="boton">📚 Listar todos</a>
            <a href="Catalogo/Categoria/Ficción" class="boton">🏷️ Categoría</a>
            <a href="Catalogo/Autor/Gabriel García Márquez" class="boton">✍️ Autor</a>
            <a href="Catalogo/Codigo/L001" class="boton">🔢 Código</a>
            <a href="Catalogo/Titulo/Cien años de soledad" class="boton">📖 Título</a>
        </div>
    </div>

</body>
</html>
