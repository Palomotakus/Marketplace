<%-- 
    Document   : inventario
    Created on : 9 oct. 2025, 02:29:45
    Author     : luisc
--%>

<%@page import="java.util.Map"%>
<%@page import="com.mycompany.frontend.entidades.Categoria"%>
<%@page import="com.mycompany.frontend.entidades.Libro"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@page import="com.mycompany.frontend.servicio.CurrencyServicio"%>
<%
    double tipoCambioVenta = CurrencyServicio.obtenerTipoCambioVenta();
%>


<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Inventario - El Buen Lector</title>

        <!-- Enlace al CSS -->
        <link rel="stylesheet" href="styles/inventario.css?v=<%= System.currentTimeMillis()%>">
    </head>
    <body>

        <%
            String rol = (String) session.getAttribute("rol");
        %>

        <div class="sidebar">
            <h2>El Buen Lector</h2>
            <p>Gestión Moderna</p>
            <!-- 📚 Enlaces visibles para todos -->
            <a href="Inventario" class="nav-item active">📚 Inventario</a>
            <a href="Venta" class="nav-item">💲 Ventas</a>

            <!-- 👥 Solo para Administrador -->
            <% if ("Administrador".equalsIgnoreCase(rol)) { %>
            <a href="Empleado" class="nav-item">👥 Empleados</a>
            <a href="Reportes" class="nav-item">📊 Reportes</a>
            <% } %>

            <!-- 🕓 Visible para todos -->
            <a href="historial.jsp" class="nav-item">🕓 Historial</a>
            <a href="Catalogo.jsp" class="nav-item"> DEMO CATALOGO</a>
            <a href="Login?accion=cerrar" class="logout">Cerrar Sesión</a>
        </div>

        <div class="main">

            <%
                int cantidadCategorias = Integer.parseInt(request.getAttribute("cantidadCategorias").toString());

            %>

            <div class="cards">
                <div class="card">
                    <h3>Total Libros</h3>
                    <div class="value"><%= ((Map) request.getAttribute("resumen")).get("totalLibros")%></div>
                </div>
                <div class="card">
                    <h3>Stock Total</h3>
                    <div class="value" style="color:#22c55e;"><%= ((Map) request.getAttribute("resumen")).get("stockTotal")%></div>
                </div>
                <div class="card">
                    <h3>Stock Bajo <11</h3>
                    <div class="value" style="color:#f97316;"><%= ((Map) request.getAttribute("resumen")).get("stockBajo")%></div>
                </div>
                <div class="card">
                    <h3>Categorías</h3>
                    <div class="value" style="color:#8b5cf6;"><%= cantidadCategorias%></div>
                </div>
            </div>

            <div class="table-section">
                <div class="table-header">
                    <div>
                        <h2>Gestión de Libros</h2>
                        <p>Administra tu inventario de manera eficiente</p>
                    </div>
                    <div class="buttons">
                        <button class="btn orange">Gestionar Categorías</button>
                        <button class="btn blue">Agregar Libro</button>
                    </div>
                    <!-- Modal Gestionar Categorías -->

                    <%
                        Boolean abrirModal = (Boolean) request.getAttribute("abrirModal");
                        if (abrirModal != null && abrirModal) {
                    %>
                    <script>
                        document.addEventListener("DOMContentLoaded", () => {
                            document.getElementById("modalCategorias").style.display = "flex";
                        });
                    </script>
                    <%
                        }
                    %>

                    <div id="modalCategorias" class="modal">
                        <div class="modal-content">
                            <span class="close">&times;</span>
                            <h2>Gestionar Categorías</h2>

                            <%
                                String error = (String) request.getAttribute("error");
                                if (error != null) {
                            %>
                            <p style="color: red; font-size: 24px; text-align: center"><%= error%></p>
                            <%
                                }
                            %>

                            <div class="nueva-categoria">
                                <h3>Agregar Nueva Categoría</h3>
                                <form id="formAgregarCategoria" action="Inventario" method="post">
                                    <input type="hidden" name="accion" value="agregarCategoria">
                                    <input type="text" name="nombre" placeholder="Nombre de la categoría" required>
                                    <button type="submit" class="btn orange">Agregar</button>
                                </form>
                            </div>

                            <h3>Categorías Existentes</h3>
                            <div class="lista-categorias">
                                <%
                                    List<Categoria> listaCategorias = (List<Categoria>) request.getAttribute("listadoCategorias");
                                    Map<Integer, Integer> librosPorCategoria = (Map<Integer, Integer>) request.getAttribute("librosPorCategoria");

                                    if (listaCategorias != null && !listaCategorias.isEmpty()) {
                                        for (Categoria c : listaCategorias) {
                                            int cantidad = 0;
                                            if (librosPorCategoria != null && librosPorCategoria.containsKey(c.getId())) {
                                                cantidad = librosPorCategoria.get(c.getId());
                                            }

                                            boolean tieneLibros = cantidad > 0;
                                %>
                                <div class="categoria-item">
                                    <span>📘 <strong><%= c.getNombre()%></strong> 
                                        (<%= cantidad%> libro<%= cantidad == 1 ? "" : "s"%>)
                                    </span>

                                    <form action="Inventario" method="post" style="display:inline;">
                                        <input type="hidden" name="accion" value="eliminarCategoria">
                                        <input type="hidden" name="id" value="<%= c.getId()%>">
                                        <button 
                                            type="submit" 
                                            class="btn delete <%= tieneLibros ? "disabled-btn" : ""%>"
                                            <%= tieneLibros ? "disabled title='No se puede eliminar una categoría con libros registrados'" : ""%>>

                                            <!-- Ícono SVG del tacho -->
                                            <svg xmlns="http://www.w3.org/2000/svg" class="icon-trash" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <polyline points="3 6 5 6 21 6"/>
                                            <path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6m5 0V4a2 2 0 0 1 2-2h0a2 2 0 0 1 2 2v2"/>
                                            <line x1="10" y1="11" x2="10" y2="17"/>
                                            <line x1="14" y1="11" x2="14" y2="17"/>
                                            </svg>
                                        </button>
                                    </form>
                                </div>
                                <%
                                    }
                                } else {
                                %>
                                <p>No hay categorías registradas.</p>
                                <%
                                    }
                                %>

                            </div>
                        </div>
                    </div>

                </div>

                <div class="search-filter">
                    <input type="text" placeholder="Buscar libros por título, autor o código..." />
                    <select>
                        <option>Todas las categorías</option>

                        <%
                            if (listaCategorias != null) {
                                for (Categoria c : listaCategorias) {
                        %>

                        <option><%= c.getNombre()%></option>

                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>CÓDIGO</th>
                            <th>TÍTULO</th>
                            <th>AUTOR</th>
                            <th>CATEGORÍA</th>
                            <th>PRECIO</th>
                            <th>STOCK</th>
                            <th>ACCIONES</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Libro> lista = (List<Libro>) request.getAttribute("listadoLibros");
                            if (lista != null) {
                                for (Libro l : lista) {

                                    String claseStock;
                                    int stock = l.getStock();
                                    if (stock >= 11) {
                                        claseStock = "green";
                                    } else if (stock >= 6 && stock <= 10) {
                                        claseStock = "red";
                                    } else {
                                        claseStock = "red";
                                    }
                        %>
                        <tr>
                            <td><%= l.getCodigo()%></td>
                            <td><%= l.getTitulo()%></td>
                            <td><%= l.getAutor()%></td>
                            <td><%= l.getCategoria().getNombre()%></td>
                            <td>
                                <strong>S/ <%= l.getPrecio()%></strong><br>
                                <small style="color:#555;">$ <%= String.format("%.2f", l.getPrecio() / tipoCambioVenta)%></small>
                            </td>
                            <td><span class="stock <%= claseStock%>"><%= l.getStock()%></span></td>

                            <td class="actions">
                                <a href="#" class="edit" data-id="<%= l.getId()%>">Editar</a>
                                <a href="Inventario?accion=eliminar&id=<%= l.getId()%>" class="delete" onclick="return confirm('¿Seguro que deseas eliminar este libro?');" class="delete">Eliminar</a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        <!-- MODAL AGREGAR LIBRO -->
        <div id="modalAgregarLibro" class="modal">
            <div class="modal-content" style="max-height: fit-content;">
                <span class="close">&times;</span>
                <h2>Agregar Libro</h2>
                <form action="Inventario" method="post">
                    <input type="hidden" name="accion" value="guardarLibro" />

                    <label>Código</label>
                    <input type="text" name="codigo" required />

                    <label>Título</label>
                    <input type="text" name="titulo" required />

                    <label>Autor</label>
                    <input type="text" name="autor" required />

                    <label>Categoría</label>
                    <select name="categoria_id" required>
                        <option value="">Seleccionar categoría</option>
                        <%
                            if (listaCategorias != null) {
                                for (Categoria c : listaCategorias) {
                        %>
                        <option value="<%= c.getId()%>"><%= c.getNombre()%></option>
                        <%
                                }
                            }
                        %>
                    </select>

                    <label>Precio</label>
                    <input type="number" step="0.01" name="precio" required />

                    <label>Stock</label>
                    <input type="number" name="stock" required min="0" />

                    <div class="modal-actions">
                        <button type="button" class="cancelar">Cancelar</button>
                        <button type="submit" class="guardar">Guardar Libro</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- MODAL EDITAR LIBRO -->
        <div id="modalEditarLibro" class="modal">
            <div class="modal-content" style="max-height: fit-content;">
                <span class="close">&times;</span>
                <h2>Editar Libro</h2>

                <form action="Inventario" method="post">
                    <input type="hidden" name="accion" value="guardarLibro" />
                    <input type="hidden" name="id" id="editId" />

                    <label>Codigo</label>
                    <input type="text" name="codigo" id="editCodigo" />

                    <label>Título</label>
                    <input type="text" name="titulo" id="editTitulo" required />

                    <label>Autor</label>
                    <input type="text" name="autor" id="editAutor" required />

                    <label>Categoría</label>
                    <select name="categoria_id" id="editCategoria" required>
                        <option value="">Seleccionar categoría</option>
                        <%
                            if (listaCategorias != null) {
                                for (Categoria c : listaCategorias) {
                        %>
                        <option value="<%= c.getId()%>"><%= c.getNombre()%></option>
                        <%
                                }
                            }
                        %>
                    </select>

                    <label>Precio</label>
                    <input type="number" step="0.01" name="precio" id="editPrecio" required />

                    <label>Stock</label>
                    <input type="number" name="stock" id="editStock" required min="0" />

                    <div class="modal-actions">
                        <button type="button" class="cancelar">Cancelar</button>
                        <button type="submit" class="guardar">Actualizar Libro</button>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const searchInput = document.querySelector(".search-filter input");
        const categorySelect = document.querySelector(".search-filter select");
        const tableBody = document.querySelector("table tbody");
        const rows = Array.from(tableBody.querySelectorAll("tr"));

        function filtrarTabla() {
            const texto = searchInput.value.toLowerCase();
            const categoriaSeleccionada = categorySelect.value.toLowerCase();

            rows.forEach(row => {
                const codigo = row.cells[0].textContent.toLowerCase();
                const titulo = row.cells[1].textContent.toLowerCase();
                const autor = row.cells[2].textContent.toLowerCase();
                const categoria = row.cells[3].textContent.toLowerCase();

                const coincideTexto =
                        codigo.includes(texto) ||
                        titulo.includes(texto) ||
                        autor.includes(texto);

                const coincideCategoria =
                        categoriaSeleccionada === "todas las categorías" ||
                        categoria === categoriaSeleccionada;

                if (coincideTexto && coincideCategoria) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }

        searchInput.addEventListener("input", filtrarTabla);
        categorySelect.addEventListener("change", filtrarTabla);
    });
</script>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        // Botones y modales
        const btnAgregar = document.querySelector(".btn.blue");
        const modalAgregar = document.getElementById("modalAgregarLibro");

        const modalEditar = document.getElementById("modalEditarLibro");
        const closeButtons = document.querySelectorAll(".modal .close, .modal .cancelar");

        // 🟦 Abrir modal "Agregar Libro"
        btnAgregar.addEventListener("click", () => {
            modalAgregar.style.display = "flex";
        });

        // 🔴 Cerrar modales (Agregar y Editar)
        closeButtons.forEach(btn => {
            btn.addEventListener("click", () => {
                modalAgregar.style.display = "none";
                modalEditar.style.display = "none";
            });
        });

        // Cerrar modal al hacer clic fuera del contenido
        window.addEventListener("click", (event) => {
            if (event.target === modalAgregar)
                modalAgregar.style.display = "none";
            if (event.target === modalEditar)
                modalEditar.style.display = "none";
        });

        // 🟨 Abrir modal "Editar Libro" con datos del libro seleccionado
        const editLinks = document.querySelectorAll(".actions .edit");

        editLinks.forEach(link => {
            link.addEventListener("click", (e) => {
                e.preventDefault();

                // ✅ Obtener el ID del libro desde el data-id del enlace
                const libroId = e.target.dataset.id;

                // Buscar la fila (tr) más cercana
                const fila = e.target.closest("tr");
                const celdas = fila.querySelectorAll("td");

                // Extraer datos
                const codigo = celdas[0].textContent.trim();
                const titulo = celdas[1].textContent.trim();
                const autor = celdas[2].textContent.trim();
                const categoria = celdas[3].textContent.trim();
                const precio = celdas[4].textContent.trim();
                const stock = celdas[5].textContent.trim();

                // Rellenar los campos del modal
                document.getElementById("editId").value = libroId;
                document.getElementById("editCodigo").value = codigo;
                document.getElementById("editTitulo").value = titulo;
                document.getElementById("editAutor").value = autor;
                document.getElementById("editPrecio").value = precio;
                document.getElementById("editStock").value = stock;

                // Seleccionar la categoría correcta en el combo
                const selectCat = document.getElementById("editCategoria");
                for (let option of selectCat.options) {
                    if (option.textContent.trim().toLowerCase() === categoria.toLowerCase()) {
                        option.selected = true;
                        break;
                    }
                }

                // Mostrar modal de edición
                modalEditar.style.display = "flex";
            });
        });
    });
</script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const btnCategorias = document.querySelector(".btn.orange");
        const modalCategorias = document.getElementById("modalCategorias");
        const closeBtnCat = modalCategorias.querySelector(".close");

        // 🟠 Abrir modal de categorías
        btnCategorias.addEventListener("click", () => {
            modalCategorias.style.display = "flex";
        });

        // 🔴 Cerrar modal
        closeBtnCat.addEventListener("click", () => {
            modalCategorias.style.display = "none";
        });

        // Cerrar al hacer clic fuera del modal
        window.addEventListener("click", (e) => {
            if (e.target === modalCategorias) {
                modalCategorias.style.display = "none";
            }
        });
    });
</script>
