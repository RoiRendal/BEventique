import React from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import "./App.css";

import Login from "./Login";
import SignUp from "./Signup";
import CustomerHome from "./CustomerHome";

function RequireAuth({ children, adminOnly = false }) {
  const raw = sessionStorage.getItem("user");
  if (!raw) {
    return <Navigate to="/login" replace />;
  }

  try {
    const user = JSON.parse(raw);

    if (adminOnly) {
      const role = (user.role || user.Role || user.roleName || "")
        .toString()
        .toLowerCase();

      if (role !== "admin") {
        return <Navigate to="/customer-home" replace />;
      }
    }
  } catch (e) {
    return <Navigate to="/login" replace />;
  }

  return children;
}

// Simple root redirect: if logged in go to customer home, otherwise to login
function AuthRedirect() {
  const raw = sessionStorage.getItem("user");
  return raw ? <Navigate to="/customer-home" replace /> : <Navigate to="/login" replace />;
}

function App() {
  return (
    <BrowserRouter>
      <Routes>

        {/* Default goes to login or customer home if session exists */}
        <Route path="/" element={<AuthRedirect />} />

        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<SignUp />} />

        {/* Customer home (protected) */}
        <Route
          path="/customer-home"
          element={
            <RequireAuth>
              <CustomerHome />
            </RequireAuth>
          }
        />

        {/* Admin/dashboard routes can be added similarly:
          <Route path="/admin" element={<RequireAuth adminOnly><Admin /></RequireAuth>} />
        */}

        {/* Fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />

      </Routes>
    </BrowserRouter>
  );
}

export default App;
