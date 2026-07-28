package com.cursos;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/estudiantes")
public class EstudianteServlet extends TableCrudServlet {
    @Override
    protected String getTableName() {
        return "ESTUDIANTES";
    }

    @Override
    protected String getViewName() {
        return "estudiantes";
    }
}
