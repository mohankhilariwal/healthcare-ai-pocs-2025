import React, { useState } from 'react';
export default function Home() {
  const [dx, setDx] = useState('Type 2 Diabetes Mellitus'); const [profile, setProfile] = useState('52yo male, BMI 34, A1c 9.2%');
  const [result, setResult] = useState(''); const [loading, setLoading] = useState(false);
  const call = async () => { setLoading(true);
    const res = await fetch('http://localhost:8004/generate_plan', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({diagnosis:dx,patient_profile:profile})});
    const d = await res.json(); setResult(d.plan || JSON.stringify(d)); setLoading(false);
  };
  return (<div className="min-h-screen bg-green-50 p-12 text-center"><h1 className="text-5xl font-bold text-green-900 mb-8">Treatment Plan Generator</h1><input className="w-96 p-4 mb-4 text-xl border-2" placeholder="Diagnosis" value={dx} onChange={e=>setDx(e.target.value)}/><input className="w-96 p-4 mb-8 text-xl border-2" placeholder="Patient profile" value={profile} onChange={e=>setProfile(e.target.value)}/><br/><button onClick={call} disabled={loading} className="px-20 py-10 bg-green-700 text-white text-4xl rounded-xl">{loading?'Generating…':'Create Plan'}</button>{result && <pre className="mt-12 p-10 bg-white text-xl border-4 border-green-700 rounded-xl whitespace-pre-wrap inline-block">{result}</pre>}</div>);
}
