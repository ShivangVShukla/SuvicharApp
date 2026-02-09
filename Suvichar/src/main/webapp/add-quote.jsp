<%@ page import="java.util.List, com.project.model.Quote, com.project.dao.QuoteDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 1. Unified Session Retrieval
    String fName = (String) session.getAttribute("userFirstName");
    String lName = (String) session.getAttribute("userLastName");
    String email = (String) session.getAttribute("userEmail");

    // 2. Security Redirect
    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 3. Name & Initials Logic
    if (fName == null || fName.trim().isEmpty()) fName = "User";
    if (lName == null || lName.trim().isEmpty()) lName = ""; 
    String initials = fName.substring(0,1).toUpperCase() + (lName.length() > 0 ? lName.substring(0,1).toUpperCase() : "");

    // 4. Page Specific Data (Only needed for my-quotes.jsp)
    QuoteDAO dao = new QuoteDAO();
    List<Quote> favorites = null;
    try {
        favorites = dao.getFavorites(email);
    } catch (Exception e) {
        favorites = new java.util.ArrayList<>(); 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Suvichar | Add Inspiration</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        /* SYNCED CSS VARIABLES */
        :root {
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --bg: #f8fafc;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.4);
            --shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        }

        [data-theme="dark"] {
            --bg: #020617;
            --text-main: #f8fafc;
            --text-muted: #94a3b8;
            --glass-bg: rgba(30, 41, 59, 0.7);
            --glass-border: rgba(255, 255, 255, 0.05);
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            background-image: radial-gradient(at 0% 0%, rgba(99, 102, 241, 0.15) 0px, transparent 50%);
            color: var(--text-main);
            min-height: 100vh;
            margin: 0;
            transition: background 0.4s ease;
        }

        header {
    background: var(--glass-bg);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-bottom: 1px solid var(--glass-border);
    padding: 15px 60px;
    position: sticky;
    top: 0;
    z-index: 1000;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

        .logo { font-size: 28px; font-weight: 800; color: var(--primary); text-decoration: none; letter-spacing: -1px; }
        nav { 
    display: flex; 
    align-items: center; 
    gap: 15px; 
}

nav a { 
    text-decoration: none; 
    color: var(--text-main); 
    font-weight: 600; 
    font-size: 13px; 
    padding: 10px 22px; 
    border-radius: 14px; 
    /* Subtle border that matches the theme text color with low opacity */
    border: 1px solid var(--glass-border);
    background: var(--glass-bg);
    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

/* Hover Effect for Inactive Buttons */
nav a:hover:not(.active-nav):not(.nav-logout) {
    border-color: var(--primary);
    transform: translateY(-3px);
    color: var(--primary);
}

/* THE GLOWING ACTIVE BUTTON */
.active-nav {
    background: var(--primary) !important;
    color: white !important;
    border-color: var(--primary) !important;
    /* Neon Glow Effect */
    box-shadow: 0 0 15px rgba(99, 102, 241, 0.4), 0 0 5px rgba(99, 102, 241, 0.2);
    transform: scale(1.05);
}

/* Red Glow for Logout on Hover */
.nav-logout {
    border: 1px solid rgba(239, 68, 68, 0.3);
    color: #ef4444 !important;
}

.nav-logout:hover {
    background: #ef4444 !important;
    color: white !important;
    box-shadow: 0 0 15px rgba(239, 68, 68, 0.4);
    transform: translateY(-3px);
}
        .main-container { 
            padding: 80px 20px; 
            max-width: 600px; 
            margin: 0 auto; 
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .form-card {
            background: var(--glass-bg);
            backdrop-filter: blur(16px);
            border: 1px solid var(--glass-border);
            border-radius: 32px;
            padding: 50px;
            width: 100%;
            box-shadow: var(--shadow);
        }

        h1 { font-size: 32px; font-weight: 800; margin-bottom: 10px; letter-spacing: -1px; text-align: center; }
        .subtitle { color: var(--text-muted); text-align: center; margin-bottom: 40px; }

        .input-group { margin-bottom: 25px; }
        .input-group label { display: block; font-weight: 600; font-size: 14px; margin-bottom: 8px; color: var(--text-muted); }

        input, textarea {
            width: 100%;
            padding: 15px;
            border-radius: 14px;
            border: 1px solid var(--glass-border);
            background: rgba(255, 255, 255, 0.5);
            color: var(--text-main);
            font-family: inherit;
            font-size: 15px;
            box-sizing: border-box;
            transition: 0.3s;
        }

        [data-theme="dark"] input, [data-theme="dark"] textarea {
            background: rgba(15, 23, 42, 0.5);
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        }

        .submit-btn {
            width: 100%;
            background: var(--primary);
            color: white;
            border: none;
            padding: 16px;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }
        
        .user-info { 
    text-align: right; 
}

.avatar {
    width: 42px; height: 42px; 
    background: linear-gradient(135deg, var(--primary), #a855f7);
    color: white; border-radius: 50%; 
    display: flex; justify-content: center; align-items: center;
    font-weight: bold; font-size: 14px; border: 2px solid white;
    box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
}

        .submit-btn:hover {
            background: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -5px rgba(99, 102, 241, 0.4);
        }

        .theme-toggle { 
            background: var(--glass-bg); border: 1px solid var(--glass-border); 
            padding: 8px; border-radius: 12px; cursor: pointer; font-size: 18px;
        }
        
        .profile-box { 
    display: flex; 
    align-items: center; 
    gap: 15px; 
}
footer {
    background: var(--glass-bg);
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
    border-top: 1px solid var(--glass-border);
    padding: 30px 60px;
    margin-top: 80px; /* Space from the main content */
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: var(--text-muted);
    font-size: 14px;
    font-weight: 500;
}

.footer-brand {
    font-weight: 800;
    color: var(--primary);
    text-decoration: none;
    letter-spacing: -0.5px;
}

.footer-links {
    display: flex;
    gap: 25px;
}

.footer-links a {
    text-decoration: none;
    color: var(--text-muted);
    transition: 0.3s;
}

.footer-links a:hover {
    color: var(--primary);
}

.copyright {
    opacity: 0.8;
}
    </style>
</head>
<body id="mainBody">

    <header>
    <a href="home.jsp" class="logo">सुविचार</a>
    <nav>
    <%-- Logic to detect current page and apply the glow class --%>
    <% String uri = request.getRequestURI(); %>
    
    <a href="home.jsp" class="<%= uri.contains("home.jsp") ? "active-nav" : "" %>">Home</a>
    
    <a href="add-quote.jsp" class="<%= uri.contains("add-quote.jsp") ? "active-nav" : "" %>">Add Quotes</a>
    
    <a href="my-quotes.jsp" class="<%= uri.contains("my-quotes.jsp") ? "active-nav" : "" %>">Favorites</a>
    
    <a href="auth?action=logout" class="nav-logout">Logout</a>
</nav>

    <div class="profile-box">
        <button class="theme-toggle" onclick="toggleTheme()" id="tBtn">🌙</button>
        <div class="user-info">
            <div style="font-weight: 700; font-size: 14px;">Hi, <%= fName %></div>
            <div style="font-size: 11px; color: var(--text-muted);">Today's Wisdom</div>
        </div>
        <div class="avatar"><%= initials %></div>
    </div>
</header>

    <div class="main-container">
        <div class="form-card">
            <h1>Add Wisdom</h1>
            <p class="subtitle">Contribute to the master collection.</p>
            
            <form action="addQuote" method="POST">
                <div class="input-group">
                    <label>The Quote</label>
                    <textarea name="quoteText" rows="4" placeholder="Enter an inspiring thought..." required></textarea>
                </div>
                
                <div class="input-group">
                    <label>Author</label>
                    <input type="text" name="quoteAuthor" placeholder="Who said this?" required>
                </div>
                
                <button type="submit" class="submit-btn">Publish Quote</button>
            </form>
        </div>
    </div>

    <script>
        function toggleTheme() {
            const b = document.getElementById('mainBody');
            const t = document.getElementById('tBtn');
            if (b.hasAttribute('data-theme')) {
                b.removeAttribute('data-theme');
                t.innerText = '🌙';
                localStorage.setItem('theme', 'light');
            } else {
                b.setAttribute('data-theme', 'dark');
                t.innerText = '☀️';
                localStorage.setItem('theme', 'dark');
            }
        }

        if (localStorage.getItem('theme') === 'dark') {
            document.getElementById('mainBody').setAttribute('data-theme', 'dark');
            document.getElementById('tBtn').innerText = '☀️';
        }
    </script>
    <footer>
    Created by <span class="creator-name">Shivang Shukla</span>
</footer>
</body>
</html>