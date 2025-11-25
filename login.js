export default function Login() {
  return (
    <div className="auth-container">
      {/* logo column */}
      <div className="auth-logo-col">
        <img
          className="auth-logo"
          src="assets/Blue White Bold Playful Kids Clothing Logo.png"
          alt="Logo"
        />
      </div>

      {/* form column */}
      <div className="auth-form-col">
        <form className="auth-form" method="post" action="authenticate.php">
          <h2>Login</h2>

          <label htmlFor="email">Email</label>
          <input id="email" name="email" type="email" required />

          <label htmlFor="password">Password</label>
          <input id="password" name="password" type="password" required />

          <button type="submit">Login</button>

          <p>
            Don’t have an account? <a href="signup.php">Sign up</a>
          </p>
        </form>
      </div>
    </div>
  );
}
