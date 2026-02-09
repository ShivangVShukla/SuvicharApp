package com.project.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.project.dao.UserDAO;
import com.project.model.User;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        // Debug: See what action is being received
        System.out.println("Action received: " + action);

        try {
            if ("signup".equals(action)) {
                User newUser = new User(
                    request.getParameter("firstName"),
                    request.getParameter("lastName"),
                    request.getParameter("email"),
                    request.getParameter("password")
                );
                
                if (userDAO.registerUser(newUser)) {
                    response.sendRedirect("login.jsp?msg=success");
                } else {
                    response.sendRedirect("login.jsp?error=signup_failed");
                }
                
            } else if ("login".equals(action)) {
                String email = request.getParameter("email");
                String password = request.getParameter("password");

                // FETCH THE FULL USER DATA
                User user = userDAO.getUserByEmail(email);

                // Check if user exists and password matches
                if (user != null && user.getPassword().equals(password)) {
                    HttpSession session = request.getSession();
                    
                    // Essential for your initials circle in home.jsp
                    session.setAttribute("userFirstName", user.getFirstName());
                    session.setAttribute("userLastName", user.getLastName());
                    session.setAttribute("userEmail", user.getEmail());
                    
                    System.out.println("Login Successful for: " + email);
                    response.sendRedirect("home.jsp"); 
                } else {
                    System.out.println("Login Failed: User not found or password mismatch.");
                    response.sendRedirect("login.jsp?error=nosuchuser");
                }
            }
        } catch (SQLException e) {
            System.err.println("Database Error in AuthServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=database");
        } catch (Exception e) {
            System.err.println("Unexpected Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=system");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); // Ends the user session
            }
            response.sendRedirect("login.jsp"); // Back to login
        }
    }
}