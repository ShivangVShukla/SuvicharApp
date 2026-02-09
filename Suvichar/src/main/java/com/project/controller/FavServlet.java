package com.project.controller;

import com.project.dao.QuoteDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/FavServlet")
public class FavServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");

        if (email == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String text = request.getParameter("text");
        String author = request.getParameter("author");

        QuoteDAO dao = new QuoteDAO();
        try {
            // Check for duplicates
            boolean exists = dao.getFavorites(email).stream()
                    .anyMatch(q -> q.getText().equalsIgnoreCase(text));

            if (!exists) {
                dao.saveToFavorites(email, text, author);
                response.getWriter().write("success");
            } else {
                response.setStatus(HttpServletResponse.SC_CONFLICT); // 409
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}