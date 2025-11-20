/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.frontend.servlets;

import com.mycompany.frontend.entidades.Empleado;
import com.mycompany.frontend.servicio.EmpleadoServicio;
import com.mycompany.frontend.servicio.EmpleadoServicioImpl;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author luisc
 */
@WebServlet(name = "EmpleadoServlet", urlPatterns = {"/EmpleadoServlet"})
public class EmpleadoServlet extends HttpServlet {

    private EmpleadoServicio empleadoServicio = new EmpleadoServicioImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accion = request.getParameter("accion");

        if (accion == null) {
            List<Empleado> lista = empleadoServicio.findAll();
            request.setAttribute("listadoEmpleados", lista);
            Map<String, Integer> estadisticas = empleadoServicio.obtenerEstadisticasEmpleados();
            request.setAttribute("estadisticas", estadisticas);
            request.getRequestDispatcher("/empleados.jsp").forward(request, response);

        } else if (accion.equals("actualizarEstado")) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nuevoEstado = request.getParameter("estado");

            // Actualiza el estado en la base de datos
            empleadoServicio.actualizarEstado(nuevoEstado, id);

            // Redirige al listado
            response.sendRedirect("Empleado");

        } else if (accion.equals("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            empleadoServicio.eliminar(id);
            response.sendRedirect("Empleado");

        } else if (accion.equals("obtenerEmpleadoJson")) {

            int id = Integer.parseInt(request.getParameter("id"));
            Empleado empleado = empleadoServicio.findById(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            if (empleado != null) {
                String json = String.format(
                        "{\"id\": %d, \"dni\": \"%s\", \"nombre\": \"%s\", \"usuario\": \"%s\", \"contrasena\": \"%s\", \"rol\": \"%s\"}",
                        empleado.getId(),
                        empleado.getDni(),
                        empleado.getNombre(),
                        empleado.getUsuario(),
                        empleado.getContrasena(),
                        empleado.getRol()
                );
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{}");
            }
        }

    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    Empleado e = new Empleado();
    e.setDni(request.getParameter("dni"));
    e.setNombre(request.getParameter("nombre"));
    e.setUsuario(request.getParameter("usuario"));
    e.setContrasena(request.getParameter("contrasena"));
    e.setRol(request.getParameter("rol"));

    // Formatear la fecha actual
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String fechaFormateada = sdf.format(new Date());
    e.setFechaRegistro(fechaFormateada);

    // Si viene el ID → es actualización
    String idParam = request.getParameter("id");
    if (idParam != null && !idParam.isEmpty()) {
        e.setId(Long.parseLong(idParam));
        e.setFechaRegistro(fechaFormateada); // misma fecha formateada
    }

    empleadoServicio.guardar(e);

    response.sendRedirect("Empleado");
}


    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
