/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package com.mycompany.frontend.servicio;

import com.mycompany.frontend.entidades.Empleado;
import java.util.List;
import java.util.Map;

/**
 *
 * @author luisc
 */
public interface EmpleadoServicio {
    
    Empleado findById(int id);
    List<Empleado> findAll();
    void guardar(Empleado empleado);
    void actualizar(Empleado empleado);
    void eliminar(int id);
    Map<String, Integer> obtenerEstadisticasEmpleados();
    void actualizarEstado(String estado, int id);
    Empleado validarUsuario(String usuario, String contrasena);
    
}
