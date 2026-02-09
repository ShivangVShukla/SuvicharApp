package com.project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.project.dao.QuoteDAO;

@WebServlet("/deleteFav")
public class DeleteFavServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuoteDAO quoteDAO = new QuoteDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
        String text = request.getParameter("text");

        if (email != null && text != null) {
            try {
                // This matches the new method we added to QuoteDAO
                quoteDAO.removeFavorite(email, text);
                response.setStatus(HttpServletResponse.SC_OK);
            } catch (IOException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}