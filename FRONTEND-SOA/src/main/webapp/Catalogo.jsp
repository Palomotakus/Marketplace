<%-- 

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
            <h2>Mundo Libros</h2>
            <p>Precios mas baratos</p>
            <!-- 📚 Enlaces visibles para todos -->
            <a href="Inventario" class="nav-item">📚 Inventario</a>
            <!-- 🕓 Visible para todos -->
            <a href="Catalogo.jsp" class="nav-item active">CATALOGO</a>
            <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
        </div>

        <div class="main">
    <div class="catalogo-container">

        <h1 class="titulo-tienda">📚 Catálogo de Libros</h1>

        <div class="filtros">
            <input type="text" placeholder="🔍 Buscar libro, autor o código...">

            <select>
                <option value="">Categorías</option>
                <option>Ficción</option>
                <option>Romance</option>
                <option>Ciencia</option>
                <option>Historia</option>
            </select>

            <select>
                <option value="">Ordenar por</option>
                <option>Precio (menor a mayor)</option>
                <option>Precio (mayor a menor)</option>
                <option>Título A-Z</option>
                <option>Título Z-A</option>
            </select>
        </div>

        <div class="grid-libros">

            <!-- Tarjeta base (más adelante será dinámica con servlet) -->
            <div class="libro-card">
                <img src="img/libro1.jpg" alt="Libro">
                <h3>Cien años de soledad</h3>
                <p class="autor">Gabriel García Márquez</p>
                <p class="categoria">Ficción · Realismo mágico</p>
                <p class="precio">S/ 45.00</p>
                <button class="btn-comprar">Agregar al carrito</button>
            </div>

            <div class="libro-card">
                <img src="img/libro2.jpg" alt="Libro">
                <h3>El Principito</h3>
                <p class="autor">Antoine de Saint-Exupéry</p>
                <p class="categoria">Infantil · Filosofía</p>
                <p class="precio">S/ 29.00</p>
                <button class="btn-comprar">Agregar al carrito</button>
            </div>

            <div class="libro-card">
                <img src="img/libro3.jpg" alt="Libro">
                <h3>1984</h3>
                <p class="autor">George Orwell</p>
                <p class="categoria">Distopía</p>
                <p class="precio">S/ 38.00</p>
                <button class="btn-comprar">Agregar al carrito</button>
            </div>

            <!-- Más tarjetas... -->
        </div>
    </div>
</div>




    </body>
</html>
