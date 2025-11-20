<%@page import="com.mycompany.frontend.servicio.VentaServicioImpl"%>
<%@page import="com.mycompany.frontend.servicio.VentaServicio"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.frontend.entidades.Venta" %>
<%@ page import="com.mycompany.frontend.entidades.DetalleVenta" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title>Historial de Ventas - El Buen Lector</title>

        <!-- Tailwind CDN -->
        <script src="https://cdn.tailwindcss.com"></script>

        <!-- Enlace al CSS personalizado -->
        <link rel="stylesheet" href="styles/historial.css?v=<%= System.currentTimeMillis()%>">

        <!-- Iconos de Lucide -->
        <script src="https://unpkg.com/lucide@latest"></script>
    </head>
    <body class="bg-gray-100 font-sans">

        <!-- Contenedor general -->
        <div class="flex h-screen">

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
                <a href="historial.jsp" class="nav-item active">🕓 Historial</a>
                <a href="Catalogo.jsp" class="nav-item"> DEMO CATALOGO</a>
                <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
            </div>


            <!-- Contenido principal -->
            <main class="flex-1 p-8 overflow-y-auto">
                <h2 class="text-2xl font-bold text-gray-800">Historial de Ventas</h2>
                <p class="text-gray-500 mb-6">Consulta el detalle completo de todas las transacciones</p>

                <!-- ==================== FILTROS ==================== -->
                <section class="bg-white rounded-2xl shadow p-6 mb-8">
                    <div class="flex items-center gap-2 mb-4">
                        <div class="bg-purple-600 text-white p-2 rounded-lg">
                            <i data-lucide="search" class="w-5 h-5"></i>
                        </div>
                        <h3 class="font-bold text-gray-800 text-lg">Filtros de Búsqueda</h3>
                    </div>

                    <form method="get" class="grid grid-cols-1 md:grid-cols-4 gap-4">
                        <div>
                            <label class="block text-sm font-semibold text-gray-600 mb-1">Número de Venta</label>
                            <input type="text" name="idVenta" placeholder="Ej: 000001" class="input-field"
                                   value="<%= request.getParameter("idVenta") != null ? request.getParameter("idVenta") : ""%>">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-gray-600 mb-1">DNI del Cliente</label>
                            <input type="text" name="dni" placeholder="Ej: 12345678" class="input-field"
                                   value="<%= request.getParameter("dni") != null ? request.getParameter("dni") : ""%>">
                        </div>
                        <div>
                            <label class="block text-sm font-semibold text-gray-600 mb-1">Fecha de Venta</label>
                            <input type="date" name="fecha" class="input-field"
                                   value="<%= request.getParameter("fecha") != null ? request.getParameter("fecha") : ""%>">
                        </div>
                        <div class="flex items-end gap-2">
                            <button type="submit" class="btn-primary">Buscar Ventas</button>
                            <button type="button" class="btn-secondary" onclick="window.location = 'historial.jsp'">Limpiar</button>
                        </div>
                    </form>
                </section>

                <!-- ==================== TRANSACCIONES ==================== -->
                <section class="bg-white rounded-2xl shadow p-6">
                    <div class="flex items-center justify-between mb-4">
                        <div class="flex items-center gap-2">
                            <div class="bg-green-600 text-white p-2 rounded-lg">
                                <i data-lucide="file-text" class="w-5 h-5"></i>
                            </div>
                            <h3 class="font-bold text-gray-800 text-lg">Transacciones Registradas</h3>
                        </div>
                        <%
                            VentaServicio ventaDAO = new VentaServicioImpl();
                            String idVenta = request.getParameter("idVenta");
                            String dni = request.getParameter("dni");
                            String fecha = request.getParameter("fecha");

                            List<Venta> listaVentas;

                            if ((idVenta != null && !idVenta.trim().isEmpty())
                                    || (dni != null && !dni.trim().isEmpty())
                                    || (fecha != null && !fecha.trim().isEmpty())) {
                                listaVentas = ventaDAO.buscarVentas(idVenta, dni, fecha);
                            } else {
                                listaVentas = ventaDAO.findAll();
                            }
                        %>
                        <span class="bg-blue-100 text-blue-700 text-sm px-3 py-1 rounded-full">
                            <%= listaVentas != null ? listaVentas.size() + " venta(s)" : "0 ventas"%>
                        </span>
                    </div>

                    <!-- ====== Tarjetas de ventas ====== -->
                    <%
                        if (listaVentas != null && !listaVentas.isEmpty()) {
                            for (Venta v : listaVentas) {
                    %>
                    <div class="rounded-2xl border border-gray-200 overflow-hidden mb-4">
                        <div class="flex justify-between items-start bg-blue-50 p-4">
                            <div>
                                <h4 class="font-semibold text-gray-800">Venta #<%= String.format("%06d", v.getId())%></h4>
                                <p class="text-gray-500 text-sm"><%= v.getFecha()%></p>
                            </div>
                            <div class="text-right">
                                <p class="text-green-600 font-bold text-lg">S/ <%= v.getTotal()%></p>
                                <p class="text-gray-500 text-sm"><%= v.getDetalles().size()%> libro(s)</p>
                            </div>
                        </div>

                        <div class="p-4 bg-gray-50">
                            <p class="font-semibold text-gray-700 mb-2">Cliente:</p>
                            <p class="text-gray-800">
                                <i data-lucide="user" class="inline w-4 h-4 mr-1"></i> 
                                <%= v.getNombre() + " " + v.getApellidoPaterno()
                                + (v.getApellidoMaterno() != null ? " " + v.getApellidoMaterno() : "")%>
                            </p>
                            <p class="text-gray-600 text-sm">
                                <i data-lucide="id-card" class="inline w-4 h-4 mr-1"></i> DNI: <%= v.getDni()%>
                            </p>

                            <hr class="my-3">

                            <p class="font-semibold text-gray-700 mb-2">Libros Vendidos:</p>

                            <%
                                for (DetalleVenta d : v.getDetalles()) {
                            %>
                            <div class="flex justify-between mb-1">
                                <div>
                                    <p class="font-medium text-gray-800">Libro ID: <%= d.getIdLibro()%></p>
                                    <p class="text-sm text-blue-600">Cantidad: <%= d.getCantidad()%> × S/ <%= d.getPrecioUnitario()%></p>
                                </div>
                                <p class="text-green-600 font-bold">S/ <%= d.getSubtotal()%></p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                    <%
                        }
                    } else {
                    %>
                    <p class="text-center text-gray-500 italic">No hay ventas registradas.</p>
                    <%
                        }
                    %>
                </section>
            </main>
        </div>

        <script>
            lucide.createIcons();
        </script>
    </body>
</html>
