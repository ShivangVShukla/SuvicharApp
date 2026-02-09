<%@ page import="java.util.List, com.project.model.Quote, com.project.dao.QuoteDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String fName = (String) session.getAttribute("userFirstName");
    String lName = (String) session.getAttribute("userLastName");
    String email = (String) session.getAttribute("userEmail");

    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (fName == null || fName.trim().isEmpty()) fName = "User";
    if (lName == null || lName.trim().isEmpty()) lName = ""; 
    String initials = fName.substring(0,1).toUpperCase() + (lName.length() > 0 ? lName.substring(0,1).toUpperCase() : "");

    QuoteDAO dao = new QuoteDAO();
    Quote qotd = null;
    List<Quote> dailyQuotes = null;

    try {
        // Fetch all quotes for QOTD logic
        List<Quote> allQuotes = dao.getAllQuotes();
        if (allQuotes != null && !allQuotes.isEmpty()) {
            long seed = java.time.LocalDate.now().toEpochDay();
            java.util.Random rand = new java.util.Random(seed);
            qotd = allQuotes.get(rand.nextInt(allQuotes.size()));
        }
        // Grid quotes
        dailyQuotes = dao.getRandomMasterQuotes();
    } catch (Exception e) {
        dailyQuotes = new java.util.ArrayList<>(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Suvichar | Home</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <style>
        :root {
            --primary: #6366f1;
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
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text-main); margin: 0; transition: 0.4s; }
        header { background: var(--glass-bg); backdrop-filter: blur(12px); border-bottom: 1px solid var(--glass-border); padding: 15px 60px; position: sticky; top: 0; z-index: 1000; display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 28px; font-weight: 800; color: var(--primary); text-decoration: none; }
        nav { display: flex; align-items: center; gap: 20px; }
        nav a { text-decoration: none; color: var(--text-main); font-weight: 600; padding: 10px 20px; border-radius: 12px; border: 1px solid var(--glass-border); transition: 0.3s; }
        .active-nav { background: var(--primary); color: white !important; box-shadow: 0 0 15px rgba(99, 102, 241, 0.4); }
        
        .main-container { padding: 40px 60px; max-width: 1200px; margin: 0 auto; }
        .qotd-hero { background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 24px; padding: 50px; text-align: center; margin-bottom: 40px; box-shadow: var(--shadow); }
        .qotd-text { font-size: 2.2rem; font-weight: 800; background: linear-gradient(to right, var(--primary), #a855f7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 15px; }
        
        .quote-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 25px; }
        .quote-card { background: var(--glass-bg); border: 1px solid var(--glass-border); border-radius: 20px; padding: 30px; transition: 0.3s; box-shadow: var(--shadow); display: flex; flex-direction: column; justify-content: space-between; }
        .quote-card:hover { transform: translateY(-5px); }
        
        .action-btns { display: flex; gap: 12px; align-items: center; justify-content: center; }
        .fav-btn { background: none; border: none; font-size: 22px; cursor: pointer; transition: 0.2s; padding: 5px; }
        
        #toast { visibility: hidden; position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%); background: var(--primary); color: white; padding: 15px 30px; border-radius: 10px; z-index: 2000; transition: 0.3s; }
        #toast.show { visibility: visible; }
        
        footer { padding: 30px; text-align: center; border-top: 1px solid var(--glass-border); margin-top: 50px; font-weight: 600; color: var(--text-muted); }
        .creator-name { background: linear-gradient(to right, var(--primary), #a855f7); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 800; }
    </style>
</head>
<body id="mainBody">
    <header>
        <a href="home.jsp" class="logo">Suvichar</a>
        <nav>
            <a href="home.jsp" class="active-nav">Home</a>
            <a href="add-quote.jsp">Add Quotes</a>
            <a href="my-quotes.jsp">Favorites</a>
            <a href="auth?action=logout" style="color:#ef4444 !important; font-weight:700; text-decoration:none;">Logout</a>
        </nav>
        <div style="display:flex; align-items:center; gap:15px;">
            <button onclick="toggleTheme()" style="background:none; border:none; cursor:pointer; font-size:20px;">🌙</button>
            <div style="width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary), #a855f7); color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-weight: bold; border: 2px solid white;"><%= initials %></div>
        </div>
    </header>

    <div class="main-container">
        <% if (qotd != null) { %>
            <div class="qotd-hero" id="hero-quote">
                <div style="text-transform: uppercase; font-size: 11px; font-weight: 800; color: var(--primary); letter-spacing: 2px; margin-bottom: 10px;">Quote of the Day</div>
                <div class="qotd-text">"<%= qotd.getText() %>"</div>
                <div style="color: var(--text-muted); font-weight: 600; margin-bottom: 25px;">— <%= qotd.getAuthor() %></div>
                <div class="action-btns">
                    <button class="fav-btn" onclick="downloadQuote('hero-quote')" title="Download Image">📸</button>
                    <button class="fav-btn" onclick="addToFav('<%= qotd.getText().replace("'", "\\'") %>', '<%= qotd.getAuthor().replace("'", "\\'") %>', this)">🤍</button>
                </div>
            </div>
        <% } %>

        <div class="quote-grid">
            <% if(dailyQuotes != null) { 
                int i = 0;
                for(Quote q : dailyQuotes) { i++; %>
                <div class="quote-card" id="card-<%= i %>">
                    <div style="font-weight: 700; font-size: 1.1rem; line-height: 1.5; margin-bottom: 20px;">"<%= q.getText() %>"</div>
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <span style="font-size: 13px; color: var(--text-muted); font-weight: 600;">— <%= q.getAuthor() %></span>
                        <div class="action-btns">
                            <button class="fav-btn" onclick="downloadQuote('card-<%= i %>')">📸</button>
                            <button class="fav-btn" onclick="addToFav('<%= q.getText().replace("'", "\\'") %>', '<%= q.getAuthor().replace("'", "\\'") %>', this)">🤍</button>
                        </div>
                    </div>
                </div>
            <% } } %>
        </div>
    </div>

    <div id="toast"></div>
    <footer>Created by <span class="creator-name">Shivang Shukla</span></footer>

    <script>
        function showToast(m) {
            const t = document.getElementById("toast");
            t.innerText = m; t.className = "show";
            setTimeout(() => t.className = "", 3000);
        }

        function toggleTheme() {
            const b = document.getElementById('mainBody');
            b.hasAttribute('data-theme') ? b.removeAttribute('data-theme') : b.setAttribute('data-theme', 'dark');
        }

        function addToFav(t, a, btn) {
            const p = new URLSearchParams();
            p.append('text', t);
            p.append('author', a);

            fetch("<%= request.getContextPath() %>/FavServlet", { 
                method: 'POST', 
                body: p 
            })
            .then(res => {
                if(res.ok) {
                    btn.innerHTML = "💖";
                    showToast("Saved to Favorites! ❤️");
                } else if(res.status === 409) {
                    showToast("Already in Favorites! ✨");
                }
            })
            .catch(() => showToast("Connection Error ❌"));
        }

        function downloadQuote(id) {
            const el = document.getElementById(id);
            const btns = el.querySelector('.action-btns');
            if(btns) btns.style.visibility = 'hidden';
            
            showToast("Generating image...");
            html2canvas(el, { backgroundColor: null, scale: 3, borderRadius: 24 }).then(canvas => {
                if(btns) btns.style.visibility = 'visible';
                const link = document.createElement('a');
                link.download = 'Suvichar_Quote.png';
                link.href = canvas.toDataURL();
                link.click();
                showToast("Downloaded! ✅");
            });
        }
    </script>
</body>
</html>