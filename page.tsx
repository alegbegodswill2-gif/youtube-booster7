"use client";
import { useEffect, useState } from "react";
import { supabase } from "@/lib/supabaseClient";

export default function Reports() {
  const [reports, setReports] = useState([]);

  useEffect(() => {
    const getReports = async () => {
      const { data } = await supabase
        .from("reports")
        .select("*, users (email)")
        .order("created_at", { ascending: false });
      setReports(data || []);
    };
    getReports();
  }, []);

  return (
    <div className="p-6">
      <h1 className="text-xl font-bold">Your Reports</h1>
      <ul>
        {reports.map((r, i) => (
          <li key={i} className="border-b py-2">
            <p>{r.note ?? (r.subscribers ? `Subs: ${r.subscribers}, Views: ${r.views}` : '')}</p>
            <span className="text-sm text-gray-500">{new Date(r.created_at).toLocaleString()}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
