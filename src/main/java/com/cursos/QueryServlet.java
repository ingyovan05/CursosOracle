package com.cursos;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/consultas")
public class QueryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/consultas.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sql = req.getParameter("sql");
        List<Map<String, Object>> rows = new ArrayList<>();
        List<String> columns = new ArrayList<>();
        Map<String, String> displayColumns = new LinkedHashMap<>();
        String error = null;
        try (Connection conn = DbConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            ResultSetMetaData md = rs.getMetaData();
            for (int i = 1; i <= md.getColumnCount(); i++) {
                String column = md.getColumnLabel(i);
                columns.add(column);
                displayColumns.put(column, OracleTableService.formatColumnName(column));
            }
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (String column : columns) {
                    row.put(column, rs.getObject(column));
                }
                rows.add(row);
            }
        } catch (SQLException e) {
            error = e.getMessage();
        }

        req.setAttribute("sql", sql);
        req.setAttribute("columns", columns);
        req.setAttribute("displayColumns", displayColumns);
        req.setAttribute("rows", rows);
        req.setAttribute("error", error);
        req.getRequestDispatcher("/consultas.jsp").forward(req, resp);
    }
}
