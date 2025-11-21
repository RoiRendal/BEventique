import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import "./DesignerHome.css";

export default function DesignerHome() {
  const navigate = useNavigate();

  useEffect(() => {
    const raw = sessionStorage.getItem("user");
    if (!raw) {
      navigate("/login", { replace: true });
      return;
    }
    try {
      const user = JSON.parse(raw);
      const role = (user.role || user.Role || "").toString().toLowerCase();
      if (role !== "designer") {
        // If not designer, redirect to appropriate home
        if (role === "admin") navigate("/admin", { replace: true });
        else navigate("/customer-home", { replace: true });
      }
    } catch {
      navigate("/login", { replace: true });
    }
  }, [navigate]);

  const handleLogout = () => {
    sessionStorage.removeItem("user");
    sessionStorage.removeItem("flash");
    navigate("/login", { replace: true });
  };

  return (
    <div className="dh-root">
      <aside className="dh-sidebar">
        <div className="dh-brand">Baby’s Eventique — Designer</div>

        <nav className="dh-nav">
          <button className="dh-nav-item" onClick={() => navigate("/designer-home")}>Home</button>
          <button className="dh-nav-item" onClick={() => navigate("/designer-packages")}>Manage Packages</button>
          <button className="dh-nav-item" onClick={() => navigate("/designer-events")}>Manage Events</button>
          <button className="dh-nav-item" onClick={() => navigate("/designer-queries")}>Design Queries</button>
        </nav>

        <div className="dh-footer">
          <button className="dh-logout" onClick={handleLogout}>Logout</button>
        </div>
      </aside>

      <main className="dh-main">
        <header className="dh-header">
          <h1>Designer Dashboard</h1>
          <p>Welcome back — manage your packages, events, and client design queries here.</p>
        </header>

        <section className="dh-content">
          <div className="dh-card">
            <h2>Recent Design Requests</h2>
            <p>Placeholder — load design queries or assignments here.</p>
          </div>

          <div className="dh-card">
            <h2>Quick Actions</h2>
            <div className="dh-actions">
              <button onClick={() => navigate("/designer-packages")} className="dh-btn">Create Package</button>
              <button onClick={() => navigate("/designer-events")} className="dh-btn ghost">New Event</button>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
