<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Centro de Reportes - El Buen Lector</title>
        <link rel="stylesheet" href="styles/reportes.css?v=<%= System.currentTimeMillis()%>">
        <style>
            

            .main {
                
                padding: 2rem;
                flex: 1;
                min-height: 100vh;
            }

            h1 {
                font-size: 2rem;
                color: #1e293b;
                margin-bottom: 0.5rem;
            }

            .subtitle {
                color: #64748b;
                margin-bottom: 2rem;
            }

            .tabs {
                display: flex;
                gap: 1rem;
                margin-bottom: 2rem;
                border-bottom: 2px solid #e2e8f0;
                padding-bottom: 0;
            }

            .tab {
                padding: 0.75rem 1.5rem;
                background: none;
                border: none;
                color: #64748b;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                border-bottom: 3px solid transparent;
                margin-bottom: -2px;
            }

            .tab:hover {
                color: #1e293b;
            }

            .tab.active {
                color: #6366f1;
                border-bottom-color: #6366f1;
            }

            .card {
                background: white;
                border-radius: 12px;
                padding: 1.5rem;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                margin-bottom: 1.5rem;
            }

            .card h2 {
                font-size: 1.25rem;
                color: #1e293b;
                margin-bottom: 1rem;
            }

            .metrics-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .metric-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 1.5rem;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }

            .metric-card.blue {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .metric-card.green {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            .metric-card.purple {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .metric-card.orange {
                background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            }

            .metric-value {
                font-size: 2rem;
                font-weight: bold;
                margin-bottom: 0.5rem;
            }

            .metric-label {
                font-size: 0.875rem;
                opacity: 0.9;
            }

            table {
                width: 100%;
                border-collapse: collapse;
            }

            thead {
                background: #f1f5f9;
            }

            th {
                padding: 0.75rem;
                text-align: left;
                font-weight: 600;
                color: #475569;
                font-size: 0.875rem;
                text-transform: uppercase;
            }

            td {
                padding: 0.75rem;
                border-bottom: 1px solid #e2e8f0;
            }

            tbody tr:hover {
                background: #f8fafc;
            }

            .filters {
                display: flex;
                gap: 1rem;
                margin-bottom: 1.5rem;
                flex-wrap: wrap;
                align-items: center;
            }

            .filters input[type="date"] {
                padding: 0.5rem 0.75rem;
                border: 1px solid #cbd5e1;
                border-radius: 0.5rem;
                font-size: 0.875rem;
            }

            .btn {
                padding: 0.5rem 1rem;
                border: none;
                border-radius: 0.5rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                text-decoration: none;
                display: inline-block;
            }

            .btn-primary {
                background: #6366f1;
                color: white;
            }

            .btn-primary:hover {
                background: #4f46e5;
            }

            .btn-secondary {
                background: #f1f5f9;
                color: #475569;
            }

            .btn-secondary:hover {
                background: #e2e8f0;
            }

            .rank-item {
                display: flex;
                align-items: center;
                padding: 0.75rem;
                background: linear-gradient(to right, #f8fafc, #eef2ff);
                border-radius: 0.75rem;
                margin-bottom: 0.75rem;
            }

            .rank-number {
                background: #6366f1;
                color: white;
                font-weight: bold;
                width: 2rem;
                height: 2rem;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 1rem;
                font-size: 0.875rem;
            }

            .rank-info {
                flex: 1;
            }

            .rank-title {
                font-weight: 600;
                color: #1e293b;
                margin-bottom: 0.25rem;
            }

            .rank-subtitle {
                font-size: 0.875rem;
                color: #64748b;
            }

            .rank-value {
                font-weight: bold;
                color: #6366f1;
                font-size: 1.125rem;
            }

            .stock-low {
                color: #dc2626;
                font-weight: 600;
            }

            .stock-ok {
                color: #16a34a;
            }

        </style>
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
            <a href="Reportes" class="nav-item active">📊 Reportes</a>
            <% } %>

            <!-- 🕓 Visible para todos -->
            <a href="historial.jsp" class="nav-item">🕓 Historial</a>
            <a href="Catalogo.jsp" class="nav-item"> DEMO CATALOGO</a>
            <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
        </div>

        <div class="main">
            <h1>📊 Centro de Reportes</h1>
            <p class="subtitle">Análisis completo de tu negocio</p>

            <div class="tabs">
                <button class="tab <%= "dashboard".equals(request.getAttribute("vistaActual")) ? "active" : ""%>" 
                        onclick="window.location.href = 'Reportes?accion=dashboard'">
                    📈 Dashboard
                </button>
                <button class="tab <%= "ventas".equals(request.getAttribute("vistaActual")) ? "active" : ""%>" 
                        onclick="window.location.href = 'Reportes?accion=ventas'">
                    💰 Ventas
                </button>
                <button class="tab <%= "inventario".equals(request.getAttribute("vistaActual")) ? "active" : ""%>" 
                        onclick="window.location.href = 'Reportes?accion=inventario'">
                    📦 Inventario
                </button>
                <button class="tab <%= "top".equals(request.getAttribute("vistaActual")) ? "active" : ""%>" 
                        onclick="window.location.href = 'Reportes?accion=top'">
                    🏆 Rankings
                </button>
            </div>

            <%
                String vistaActual = (String) request.getAttribute("vistaActual");
                if (vistaActual == null) vistaActual = "dashboard";
            %>

            <!-- ============== DASHBOARD ============== -->
            <% if ("dashboard".equals(vistaActual)) {
                    Map<String, Object> metricas = (Map<String, Object>) request.getAttribute("metricas");
                    List<Map<String, Object>> topLibros = (List<Map<String, Object>>) request.getAttribute("topLibros");
                    List<Map<String, Object>> alertasStock = (List<Map<String, Object>>) request.getAttribute("alertasStock");
            %>

            <div class="metrics-grid">
                <div class="metric-card blue">
                    <div class="metric-value">S/ <%= String.format("%.2f", metricas != null ? metricas.get("ventasMes") : 0)%></div>
                    <div class="metric-label">Ventas del Mes</div>
                </div>
                <div class="metric-card green">
                    <div class="metric-value"><%= metricas != null ? metricas.get("librosVendidos") : 0%></div>
                    <div class="metric-label">Libros Vendidos</div>
                </div>
                <div class="metric-card purple">
                    <div class="metric-value"><%= metricas != null ? metricas.get("stockTotal") : 0%></div>
                    <div class="metric-label">Stock Total</div>
                </div>
                <div class="metric-card orange">
                    <div class="metric-value"><%= metricas != null ? metricas.get("alertasStock") : 0%></div>
                    <div class="metric-label">Alertas de Stock</div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                <div class="card">
                    <h2>🔥 Top 5 Más Vendidos</h2>
                    <% if (topLibros != null && !topLibros.isEmpty()) {
                            int pos = 1;
                            for (Map<String, Object> libro : topLibros) {%>
                    <div class="rank-item">
                        <div class="rank-number"><%= pos++%></div>
                        <div class="rank-info">
                            <div class="rank-title"><%= libro.get("titulo")%></div>
                            <div class="rank-subtitle"><%= libro.get("autor")%></div>
                        </div>
                        <div class="rank-value"><%= libro.get("totalVendido")%> unid.</div>
                    </div>
                    <% }
                    } else { %>
                    <p style="color: #94a3b8; text-align: center; padding: 2rem;">No hay datos disponibles</p>
                    <% }%>
                </div>

                <div class="card">
                    <h2>⚠️ Alertas de Stock Bajo</h2>
                    <% if (alertasStock != null && !alertasStock.isEmpty()) {
                            for (Map<String, Object> libro : alertasStock) {%>
                    <div class="rank-item">
                        <div class="rank-info">
                            <div class="rank-title"><%= libro.get("titulo")%></div>
                            <div class="rank-subtitle"><%= libro.get("categoria")%></div>
                        </div>
                        <div class="stock-low"><%= libro.get("stock")%> unid.</div>
                    </div>
                    <% }
                    } else { %>
                    <p style="color: #94a3b8; text-align: center; padding: 2rem;">✅ Todo el stock está en buen nivel</p>
                    <% }%>
                </div>
            </div>

            <% } %>

            <!-- ============== VENTAS ============== -->
            <% if ("ventas".equals(vistaActual)) {
                    List<Map<String, Object>> reporteVentas = (List<Map<String, Object>>) request.getAttribute("reporteVentas");
                    List<Map<String, Object>> ventasPorCategoria = (List<Map<String, Object>>) request.getAttribute("ventasPorCategoria");
                    String periodoSeleccionado = (String) request.getAttribute("periodoSeleccionado");
                    String fechaInicio = (String) request.getAttribute("fechaInicio");
                    String fechaFin = (String) request.getAttribute("fechaFin");
            %>

            <div class="card">
    <h2>Filtros de Ventas</h2>

    <!-- Formulario 1: botones rápidos -->
    <form action="Reportes" method="get" class="filters" style="display:flex; gap:0.5rem; align-items:center;">
        <input type="hidden" name="accion" value="ventas">
        <button type="submit" name="periodo" value="dia"
                class="btn <%= "dia".equals(periodoSeleccionado) ? "btn-primary" : "btn-secondary"%>">Hoy</button>

        <button type="submit" name="periodo" value="semana"
                class="btn <%= "semana".equals(periodoSeleccionado) ? "btn-primary" : "btn-secondary"%>">Esta Semana</button>

        <button type="submit" name="periodo" value="mes"
                class="btn <%= "mes".equals(periodoSeleccionado) ? "btn-primary" : "btn-secondary"%>">Este Mes</button>
    </form>

    <!-- Separador visual -->
    <div style="height:8px;"></div>

    <!-- Formulario 2: rango de fechas -->
    <form action="Reportes" method="get" class="filters" style="display:flex; gap:0.5rem; align-items:center;">
        <input type="hidden" name="accion" value="ventas">
        <input type="hidden" name="periodo" value="rango"> <!-- 🔹 CLAVE: indica al servlet que es un rango -->
        
        <input type="date" name="fechaInicio" value="<%= fechaInicio != null ? fechaInicio : "" %>">
        <input type="date" name="fechaFin" value="<%= fechaFin != null ? fechaFin : "" %>">

        <button type="submit" class="btn btn-primary">Aplicar Rango</button>
    </form>
</div>


                <div class="card">
                    <h2>📚 Ventas por Categoría</h2>
                    <% if (ventasPorCategoria != null && !ventasPorCategoria.isEmpty()) {
                            for (Map<String, Object> cat : ventasPorCategoria) {%>
                    <div class="rank-item">
                        <div class="rank-info">
                            <div class="rank-title"><%= cat.get("categoria")%></div>
                            <div class="rank-subtitle"><%= cat.get("librosVendidos")%> libros</div>
                        </div>
                        <div class="rank-value">S/ <%= String.format("%.2f", cat.get("totalVentas"))%></div>
                    </div>
                    <% }
                    } else { %>
                    <p style="color: #94a3b8; text-align: center; padding: 2rem;">Sin datos</p>
                    <% }%>
                </div>
            </div>

            <% } %>

            <!-- ============== INVENTARIO ============== -->
            <% if ("inventario".equals(vistaActual)) {
                    List<Map<String, Object>> inventario = (List<Map<String, Object>>) request.getAttribute("inventario");
                    Double valorTotal = (Double) request.getAttribute("valorTotalInventario");
                    List<Map<String, Object>> librosSinMovimiento = (List<Map<String, Object>>) request.getAttribute("librosSinMovimiento");
            %>

            <div class="card">
                <h2>📦 Inventario Completo</h2>
                <p style="margin-bottom: 1rem; color: #64748b;">
                    <strong>Valor Total del Inventario:</strong> S/ <%= valorTotal != null ? String.format("%.2f", valorTotal) : "0.00"%>
                </p>
                <table>
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Título</th>
                            <th>Autor</th>
                            <th>Categoría</th>
                            <th>Precio (S/)</th>
                            <th>Stock</th>
                            <th>Valor Stock (S/)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (inventario != null && !inventario.isEmpty()) {
                                for (Map<String, Object> libro : inventario) {
                                    int stock = (Integer) libro.get("stock");
                                    String stockClass = stock < 10 ? "stock-low" : "stock-ok";
                        %>
                        <tr>
                            <td><%= libro.get("codigo")%></td>
                            <td><strong><%= libro.get("titulo")%></strong></td>
                            <td><%= libro.get("autor")%></td>
                            <td><%= libro.get("categoria")%></td>
                            <td><%= String.format("%.2f", libro.get("precio"))%></td>
                            <td class="<%= stockClass%>"><%= stock%></td>
                            <td><strong>S/ <%= String.format("%.2f", libro.get("valorStock"))%></strong></td>
                        </tr>
                        <% }
                        } else { %>
                        <tr>
                            <td colspan="7" style="text-align: center; color: #94a3b8; padding: 2rem;">
                                No hay libros en el inventario
                            </td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>

            <% if (librosSinMovimiento != null && !librosSinMovimiento.isEmpty()) { %>
            <div class="card">
                <h2>⏸️ Libros Sin Movimiento (últimos 30 días)</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Título</th>
                            <th>Autor</th>
                            <th>Stock</th>
                            <th>Última Venta</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                           for (Map<String, Object> libro : librosSinMovimiento) {
                               Object ultimaVentaObj = libro.get("ultimaVenta");
                               String ultimaVentaStr = "Nunca vendido";
                               if (ultimaVentaObj != null) {
                                   ultimaVentaStr = sdf.format(ultimaVentaObj);
                               }
                        %>
                        <tr>
                            <td><strong><%= libro.get("titulo")%></strong></td>
                            <td><%= libro.get("autor")%></td>
                            <td><%= libro.get("stock")%></td>
                            <td><%= ultimaVentaStr%></td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
            <% } %>

            <% } %>

            <!-- ============== RANKINGS ============== -->
            <% if ("top".equals(vistaActual)) {
                    List<Map<String, Object>> ranking = (List<Map<String, Object>>) request.getAttribute("ranking");
                    String tipoTop = (String) request.getAttribute("tipoTopSeleccionado");
            %>

            <div class="card">
                <h2>Filtros de Ranking</h2>
                <div class="filters">
                    <a href="Reportes?accion=top&tipoTop=vendidos" class="btn <%= "vendidos".equals(tipoTop) ? "btn-primary" : "btn-secondary"%>">
                        🔥 Más Vendidos
                    </a>
                    <a href="Reportes?accion=top&tipoTop=menosVendidos" class="btn <%= "menosVendidos".equals(tipoTop) ? "btn-primary" : "btn-secondary"%>">
                        📉 Menos Vendidos
                    </a>
                </div>
            </div>

            <div class="card">
                <h2><%= "vendidos".equals(tipoTop) ? "🏆 Top 10 Libros Más Vendidos" : "📉 Top 10 Libros Menos Vendidos"%></h2>
                <% if (ranking != null && !ranking.isEmpty()) {
                        int pos = 1;
                        for (Map<String, Object> libro : ranking) { %>
                <div class="rank-item">
                    <div class="rank-number"><%= pos++ %></div>
                    <div class="rank-info">
                        <div class="rank-title"><%= libro.get("titulo") %></div>
                        <div class="rank-subtitle"><%= libro.get("autor") %> • <%= libro.get("categoria") %></div>
                    </div>
                    <div style="text-align: right;">
                        <div class="rank-value"><%= libro.get("totalVendido") %> unid.</div>
                        <div style="font-size: 0.875rem; color: #64748b;">S/ <%= String.format("%.2f", libro.get("ingresosTotales")) %></div>
                    </div>
                </div>
                <% } %>
                <% } else { %>
                <p style="color: #94a3b8; text-align: center; padding: 2rem;">
                    <%= "vendidos".equals(tipoTop) ? "No hay libros vendidos aún" : "Todos los libros en stock han sido vendidos al menos una vez"%>
                </p>
                <% } %>
            </div>

            <% } %>

        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const numbers = document.querySelectorAll('.metric-value');
                numbers.forEach(num => {
                    const value = num.textContent.trim();
                    if (!value.includes('S/') && !isNaN(value.replace(/,/g, ''))) {
                        num.textContent = parseInt(value).toLocaleString('es-PE');
                    }
                });
            });
                function filtrar(periodo) {
                window.location.href = 'Reportes?accion=ventas&periodo=' + periodo;
                }


        </script>
    </body>
</html>