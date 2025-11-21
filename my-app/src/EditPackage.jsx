import React, { useEffect, useState } from "react";
import "./EditPackage.css";

/*
  Props:
    initialPackage: {
      id, Package_Name, Description, NumTables, NumRoundTables,
      NumChairs, NumTent, NumPlatform, Package_Amount,
      photos (array) or Photo (string)
    }
    onSave(formObject, selectedFile)
    onCancel()
*/

export default function EditPackage({ initialPackage = {}, onSave, onCancel }) {
  const init = {
    id: initialPackage.id ?? "",
    Package_Name: initialPackage.Package_Name ?? "",
    Description: initialPackage.Description ?? "",
    NumTables: initialPackage.NumTables ?? 0,
    NumRoundTables: initialPackage.NumRoundTables ?? 0,
    NumChairs: initialPackage.NumChairs ?? 0,
    NumTent: initialPackage.NumTent ?? 0,
    NumPlatform: initialPackage.NumPlatform ?? 0,
    Package_Amount:
      initialPackage.Package_Amount ??
      initialPackage.PackageAmount ??
      initialPackage.price_from ??
      "",
    photos: Array.isArray(initialPackage.photos)
      ? initialPackage.photos
      : initialPackage.Photo
      ? [initialPackage.Photo]
      : [],
  };

  const [form, setForm] = useState({
    id: init.id,
    Package_Name: init.Package_Name,
    Description: init.Description,
    NumTables: init.NumTables,
    NumRoundTables: init.NumRoundTables,
    NumChairs: init.NumChairs,
    NumTent: init.NumTent,
    NumPlatform: init.NumPlatform,
    Package_Amount: init.Package_Amount,
  });

  const [selectedFile, setSelectedFile] = useState(null);
  const [preview, setPreview] = useState(init.photos[0] ?? null);

  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    return () => {
      if (preview && preview.startsWith("blob:")) {
        URL.revokeObjectURL(preview);
      }
    };
  }, [preview]);

  const handleFileChange = (e) => {
    const f = e.target.files?.[0];
    if (!f) return;

    setSelectedFile(f);

    const url = URL.createObjectURL(f);
    setPreview((prev) => {
      if (prev && prev.startsWith("blob:")) URL.revokeObjectURL(prev);
      return url;
    });
  };

  const handleSave = async () => {
    setError("");

    if (!form.Package_Name) {
      setError("Package name is required");
      return;
    }

    try {
      setSaving(true);
      await onSave(form, selectedFile);
    } catch (err) {
      setError(err.message || "Save failed");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="p-6">
      <div className="max-w-5xl mx-auto bg-white rounded-xl shadow-md overflow-hidden">
        <div className="md:flex">
          {/* LEFT IMAGE */}
          <div className="md:w-2/5 p-6 flex flex-col items-center gap-4">
            <div
              className="w-full rounded-xl border border-gray-200 shadow-sm overflow-hidden flex items-center justify-center bg-gray-50"
              style={{ height: 300 }}
            >
              {preview ? (
                <img src={preview} alt="preview" className="object-cover w-full h-full" />
              ) : (
                <div className="text-gray-500">No Image</div>
              )}
            </div>

            <div className="w-full flex items-center gap-3">
              <label className="px-4 py-2 bg-green-100 text-green-800 rounded cursor-pointer">
                Select Photo
                <input type="file" accept="image/*" className="hidden" onChange={handleFileChange} />
              </label>

              <button
                type="button"
                className="px-4 py-2 border rounded text-gray-700"
                onClick={() => {
                  setSelectedFile(null);
                  setPreview(init.photos[0] ?? null);
                }}
              >
                Reset
              </button>
            </div>
          </div>

          {/* RIGHT FORM */}
          <div className="md:w-3/5 p-6">
            <div className="space-y-4">
              {/* NAME */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Package Name</label>
                <input
                  type="text"
                  className="mt-1 block w-full rounded-md border-gray-200 shadow-sm"
                  value={form.Package_Name}
                  onChange={(e) => setForm({ ...form, Package_Name: e.target.value })}
                />
              </div>

              {/* DESCRIPTION */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Description</label>
                <textarea
                  rows="3"
                  className="mt-1 block w-full rounded-md border-gray-200 shadow-sm"
                  value={form.Description}
                  onChange={(e) => setForm({ ...form, Description: e.target.value })}
                />
              </div>

              {/* GRID FIELDS */}
              <div className="grid grid-cols-2 gap-4">
                {/* NumTables */}
                <div>
                  <label className="block text-sm font-medium text-gray-700">Num Tables</label>
                  <input
                    type="number"
                    min="0"
                    className="mt-1 block w-full rounded-md border-gray-200"
                    value={form.NumTables}
                    onChange={(e) =>
                      setForm({ ...form, NumTables: Number(e.target.value) })
                    }
                  />
                </div>

                {/* NumRoundTables (NEW FIELD) */}
                <div>
                  <label className="block text-sm font-medium text-gray-700">
                    Num Round Tables
                  </label>
                  <input
                    type="number"
                    min="0"
                    className="mt-1 block w-full rounded-md border-gray-200"
                    value={form.NumRoundTables}
                    onChange={(e) =>
                      setForm({ ...form, NumRoundTables: Number(e.target.value) })
                    }
                  />
                </div>

                {/* NumChairs */}
                <div>
                  <label className="block text-sm font-medium text-gray-700">Num Chairs</label>
                  <input
                    type="number"
                    min="0"
                    className="mt-1 block w-full rounded-md border-gray-200"
                    value={form.NumChairs}
                    onChange={(e) =>
                      setForm({ ...form, NumChairs: Number(e.target.value) })
                    }
                  />
                </div>

                {/* NumTent */}
                <div>
                  <label className="block text-sm font-medium text-gray-700">Num Tent</label>
                  <input
                    type="number"
                    min="0"
                    className="mt-1 block w-full rounded-md border-gray-200"
                    value={form.NumTent}
                    onChange={(e) =>
                      setForm({ ...form, NumTent: Number(e.target.value) })
                    }
                  />
                </div>

                {/* NumPlatform */}
                <div>
                  <label className="block text-sm font-medium text-gray-700">Num Platform</label>
                  <input
                    type="number"
                    min="0"
                    className="mt-1 block w-full rounded-md border-gray-200"
                    value={form.NumPlatform}
                    onChange={(e) =>
                      setForm({ ...form, NumPlatform: Number(e.target.value) })
                    }
                  />
                </div>
              </div>

              {/* AMOUNT */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Amount</label>
                <input
                  type="number"
                  step="0.01"
                  className="mt-1 block w-full rounded-md border-gray-200"
                  value={form.Package_Amount}
                  onChange={(e) => setForm({ ...form, Package_Amount: e.target.value })}
                />
              </div>

              {error && <div className="text-red-600">{error}</div>}

              <div className="flex gap-3">
                <button
                  onClick={handleSave}
                  disabled={saving}
                  className="px-4 py-2 bg-green-500 text-white rounded"
                >
                  {saving ? "Saving..." : "Save"}
                </button>

                <button
                  onClick={() => onCancel && onCancel()}
                  className="px-4 py-2 border rounded"
                >
                  Cancel
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
