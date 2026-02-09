<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Welcome | Secure Login</title>
    <style>
        :root {
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --bg: #f8fafc;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --error-bg: #fef2f2;
            --error-text: #b91c1c;
        }

        body { 
            font-family: 'Inter', -apple-system, sans-serif; 
            display: flex; justify-content: center; align-items: center;
            background-color: var(--bg); height: 100vh; margin: 0;
        }

        .card { 
            background: white; padding: 40px; border-radius: 20px; 
            width: 100%; max-width: 400px; 
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); 
        }

        .tabs { 
            display: flex; background: #f1f5f9; border-radius: 12px; 
            padding: 4px; margin-bottom: 30px; 
        }

        .tabs button { 
            flex: 1; padding: 12px; border: none; cursor: pointer; 
            border-radius: 8px; background: none; font-weight: 600;
            color: var(--text-muted); transition: all 0.3s ease;
        }

        .tabs button.active { 
            background: white; color: var(--primary);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); 
        }

        .hidden { display: none; }
        h2 { color: var(--text-main); margin: 0 0 8px 0; font-size: 24px; }
        p.subtitle { color: var(--text-muted); font-size: 14px; margin-bottom: 24px; }

        input { 
            width: 100%; padding: 12px 16px; border: 1px solid #e2e8f0; 
            border-radius: 8px; font-size: 15px; box-sizing: border-box;
            margin-bottom: 16px;
        }

        input:focus { outline: none; border-color: var(--primary); }

        .btn-continue { 
            width: 100%; padding: 14px; background: var(--primary); 
            color: white; border: none; border-radius: 8px; 
            font-size: 16px; font-weight: 600; cursor: pointer;
        }

        /* Password Strength Meter */
        .strength-meter {
            height: 4px; width: 100%; background: #e2e8f0;
            border-radius: 2px; margin: -10px 0 20px 0; overflow: hidden;
        }
        .strength-bar {
            height: 100%; width: 0%; transition: all 0.3s;
        }
        .strength-text { font-size: 12px; margin-bottom: 10px; display: block; }

        .alert {
            background-color: var(--error-bg); color: var(--error-text);
            padding: 12px; border-radius: 8px; font-size: 14px;
            margin-bottom: 20px; text-align: center; border: 1px solid #fecaca;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="tabs">
            <button id="loginTab" class="active" onclick="toggleForm('login')">Login</button>
            <button id="signupTab" onclick="toggleForm('signup')">Sign Up</button>
        </div>

        <% 
            String error = request.getParameter("error");
            if ("nosuchuser".equals(error)) { 
        %>
            <div class="alert">Account not found. <b>Please sign up!</b></div>
        <% } %>

        <form id="loginForm" action="auth" method="post">
            <input type="hidden" name="action" value="login">
            <h2>Sign in</h2>
            <p class="subtitle">Enter your details to access your quotes.</p>
            <input type="email" name="email" placeholder="Email address" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit" class="btn-continue">Sign In</button>
        </form>

        <form id="signupForm" action="auth" method="post" class="hidden">
            <input type="hidden" name="action" value="signup">
            <h2>Create account</h2>
            <p class="subtitle">Join us for daily inspiration.</p>
            <div style="display: flex; gap: 10px;">
                <input type="text" name="firstName" placeholder="First name" required>
                <input type="text" name="lastName" placeholder="Last name" required>
            </div>
            <input type="email" name="email" placeholder="Email address" required>
            <input type="password" id="signupPassword" name="password" placeholder="Password" required oninput="checkStrength(this.value)">
            
            <span id="strengthText" class="strength-text">Strength: Too weak</span>
            <div class="strength-meter">
                <div id="strengthBar" class="strength-bar"></div>
            </div>

            <button type="submit" class="btn-continue">Create Account</button>
        </form>
    </div>

    <script>
        function toggleForm(type) {
            const loginForm = document.getElementById('loginForm');
            const signupForm = document.getElementById('signupForm');
            const loginTab = document.getElementById('loginTab');
            const signupTab = document.getElementById('signupTab');

            if (type === 'login') {
                loginForm.classList.remove('hidden');
                signupForm.classList.add('hidden');
                loginTab.classList.add('active');
                signupTab.classList.remove('active');
            } else {
                loginForm.classList.add('hidden');
                signupForm.classList.remove('hidden');
                loginTab.classList.remove('active');
                signupTab.classList.add('active');
            }
        }

        function checkStrength(password) {
            let strength = 0;
            const bar = document.getElementById('strengthBar');
            const text = document.getElementById('strengthText');

            if (password.length > 5) strength += 25;
            if (password.match(/[A-Z]/)) strength += 25;
            if (password.match(/[0-9]/)) strength += 25;
            if (password.match(/[^A-Za-z0-9]/)) strength += 25;

            bar.style.width = strength + "%";
            
            if (strength <= 25) {
                bar.style.backgroundColor = "#ef4444";
                text.innerText = "Strength: Weak";
            } else if (strength <= 75) {
                bar.style.backgroundColor = "#f59e0b";
                text.innerText = "Strength: Medium";
            } else {
                bar.style.backgroundColor = "#10b981";
                text.innerText = "Strength: Strong";
            }
        }

        // Handle auto-switch error
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('error') === 'nosuchuser') {
                toggleForm('signup');
            }
        }
    </script>
</body>
</html>