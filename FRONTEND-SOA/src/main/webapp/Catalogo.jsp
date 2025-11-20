<%-- 
    Document   : Catalogo
    Created on : 16 oct. 2025, 11:07:11
    Author     : luisc
--%>

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

        <div class="sidebar">
            <h2>El Buen Lector</h2>
            <p>Gestión Moderna</p>
            <!-- 📚 Enlaces visibles para todos -->
            <a href="Inventario" class="nav-item">📚 Inventario</a>
            <a href="Venta" class="nav-item">💲 Ventas</a>

            <!-- 👥 Solo para Administrador -->
            <% if ("Administrador".equalsIgnoreCase(rol)) { %>
            <a href="Empleado" class="nav-item">👥 Empleados</a>
            <a href="Reportes" class="nav-item">📊 Reportes</a>
            <% }%>

            <!-- 🕓 Visible para todos -->
            <a href="historial.jsp" class="nav-item">🕓 Historial</a>
            <a href="Catalogo.jsp" class="nav-item active"> DEMO CATALOGO</a>
            <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
        </div>

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
