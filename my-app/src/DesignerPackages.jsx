import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import EditPackageModal from "./EditPackageModal";
import AddPackageModal from "./AddPackageModal";
import "./DesignerPackages.css";

export default function DesignerPackages() {
	const navigate = useNavigate();
	const [packages, setPackages] = useState([]);
	const [loading, setLoading] = useState(true);
	const [error, setError] = useState("");

	// Modal state
	const [editModalOpen, setEditModalOpen] = useState(false);
	const [editPackageId, setEditPackageId] = useState(null);
	const [addModalOpen, setAddModalOpen] = useState(false);

	useEffect(() => {
		// Role check
		const raw = sessionStorage.getItem("user");
		if (!raw) {
			navigate("/login", { replace: true });
			return;
		}
		try {
			const user = JSON.parse(raw);
			const role = (user.role || user.Role || "").toString().toLowerCase();
			if (role !== "designer") {
				navigate("/customer-home", { replace: true });
				return;
			}
		} catch {
			navigate("/login", { replace: true });
			return;
		}

		// fetch packages
		let mounted = true;
		setLoading(true);
		fetch("http://localhost:3001/api/packages/list")
			.then((res) => res.json())
			.then((packages) => {
				if (!mounted) return;
				// Node.js API returns packages array directly, not wrapped in status object
				setPackages(Array.isArray(packages) ? packages : []);
			})
			.catch((err) => {
				console.error("packages fetch error", err);
				setError("Network error");
			})
			.finally(() => {
				if (mounted) setLoading(false);
			});

		return () => { mounted = false; };
	}, [navigate]);

	// helper to refresh packages from server
	const refreshPackages = () => {
		setLoading(true);
		fetch("http://localhost:3001/api/packages/list")
			.then((res) => res.json())
			.then((packages) => {
				setPackages(Array.isArray(packages) ? packages : []);
				setError("");
			})
			.catch((err) => setError("Network error"))
			.finally(() => setLoading(false));
	};

	// Add deletePackage helper
	const deletePackage = async (pkgId) => {
		if (!window.confirm("Delete this package? This cannot be undone.")) return;
		try {
			const res = await fetch("http://localhost:3001/api/packages/delete", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ id: pkgId }),
			});
			const json = await res.json();
			if (json.status === "success") {
				refreshPackages();
			} else {
				setError(json.message || "Failed to delete package");
			}
		} catch (err) {
			console.error("delete package error", err);
			setError("Network error while deleting package");
		}
	};

	// render: show list OR editor
	return (
		<div className="dp-root">
			<aside className="dp-sidebar">
				<div className="dp-brand">Designer — Packages</div>
				<nav className="dp-nav">
					<button onClick={() => navigate("/designer-home")}>Home</button>
					<button className="active">Manage Packages</button>
					<button onClick={() => navigate("/designer-events")}>Manage Events</button>
					<button onClick={() => navigate("/designer-queries")}>Design Queries</button>
				</nav>
				<div style={{ marginTop: "auto" }}>
					<button className="dp-logout" onClick={() => { sessionStorage.removeItem("user"); navigate("/login"); }}>
						Logout
					</button>
				</div>
			</aside>

			<main className="dp-main">
				<header className="dp-header">
					<div className="dp-header-top">
						<div>
							<h1>Manage Packages</h1>
							<p>View and edit designer packages stored in the database.</p>
						</div>
						<button className="add-package-btn" onClick={() => setAddModalOpen(true)}>
							+ Add Package
						</button>
					</div>
				</header>

				<section className="dp-content">
					{loading ? (
						<div className="dp-loading">Loading packages...</div>
					) : error ? (
						<div className="dp-error">{error}</div>
					) : packages.length === 0 ? (
						<div className="dp-empty">No packages found.</div>
					) : (
						<div className="dp-table-wrap">
							<table className="dp-table">
								<thead>
									<tr>
										<th className="col-photo">Photo</th>
										<th className="col-name">Package Name</th>
										<th className="col-desc">Description</th>
										<th className="col-price">Price Range</th>
										<th className="col-status">Status</th>
										<th className="col-actions">Actions</th>
									</tr>
								</thead>

								<tbody>
									{packages.map((pkg, idx) => {
										const photos = Array.isArray(pkg.photos) ? pkg.photos.filter(Boolean) : [];
										const thumb = pkg.image || photos[0] || null;
										const packageId = pkg.Package_ID || pkg.id;
										const packageName = pkg.Package_Name || pkg.name || pkg.PackageName;
										const description = pkg.Description || pkg.description || "";
										const price = pkg.Package_Amount || pkg.price_from || "";
										const status = pkg.Status || pkg.status || "active";
										
										return (
											<tr key={packageId ?? idx} className={idx % 2 === 0 ? "row-even" : "row-odd"}>
												<td className="cell-photo">
													{thumb ? (
														<img src={thumb} alt={packageName || "thumb"} className="thumb-img" onError={(e) => e.currentTarget.src = "/assets/placeholder.png"} />
													) : (
														<div className="no-image">No Image</div>
													)}
												</td>

												<td className="cell-name">{packageName}</td>

												<td className="cell-desc">{description}</td>

												<td className="cell-price">
													{price ? `₱${price}` : "—"}
												</td>

												<td className="cell-status">{status.toString()}</td>

												<td className="cell-actions">
													<div className="actions-wrap">
														<button className="action-btn edit" onClick={() => { setEditPackageId(packageId); setEditModalOpen(true); }}>Edit</button>
														<button className="action-btn delete" onClick={() => deletePackage(packageId)}>Delete</button>
													</div>
												</td>
											</tr>
										);
									})}
								</tbody>
							</table>
						</div>
					)}
				</section>
			</main>

			{/* Edit Package Modal */}
			<EditPackageModal
				isOpen={editModalOpen}
				packageId={editPackageId}
				onClose={() => { setEditModalOpen(false); setEditPackageId(null); }}
				onSaved={() => { setEditModalOpen(false); setEditPackageId(null); refreshPackages(); }}
			/>

			{/* Add Package Modal */}
			<AddPackageModal
				isOpen={addModalOpen}
				onClose={() => setAddModalOpen(false)}
				onSaved={() => { setAddModalOpen(false); refreshPackages(); }}
			/>
		</div>
	);
}
