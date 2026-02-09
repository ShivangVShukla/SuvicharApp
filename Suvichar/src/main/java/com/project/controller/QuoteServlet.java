package com.project.controller; // Ensure this matches your folder: src/main/java/com/project/controller

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import com.project.dao.QuoteDAO;

@WebServlet("/quoteAction")
public class QuoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private QuoteDAO quoteDAO = new QuoteDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("userEmail");
        String text = request.getParameter("quoteText");
        String author = request.getParameter("author");

        // Basic validation for author
        if (author == null || author.trim().isEmpty()) {
            author = "Anonymous";
        }

        if (email != null && text != null && !text.trim().isEmpty()) {
            try {
                // This calls the method in your updated QuoteDAO
                quoteDAO.addQuote(email, text, author);
                response.sendRedirect("home.jsp?msg=added");
            } catch (IOException e) {
                e.printStackTrace();
                response.sendRedirect("add-quote.jsp?error=excel_error");
            }
        } else {
            response.sendRedirect("add-quote.jsp?error=invalid_input");
        }
    }
}