import React, { useState } from 'react';
export default function Home() {
  const [input, setInput] = useState('Severe headache, vomiting, BP 190/110');
  const [result, setResult] = useState(''); const [loading, setLoading] = useState(false);
  const call = async () => { setLoading(true);
    const res = await fetch('http://localhost:8003/triage', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({chief_complaint:input,vitals:"BP 190/110"})});
    const d = await res.json(); setResult(d.triage || JSON.stringify(d)); setLoading(false);
  };
  return (<div className="min-h-screen bg-red-50 p-12 text-center"><h1 className="text-5xl font-bold text-red-900 mb-8">Patient Triage System</h1><textarea className="w-96 h-40 p-4 border-4 text-lg" value={input} onChange={e=>setInput(e.target.value)}/><br/><button onClick={call} disabled={loading} className="mt-8 px-16 py-8 bg-red-700 text-white text-4xl rounded-xl">{loading?'Triaging…':'Calculate ESI Level'}</button>{result && <div className="mt-12 p-12 bg-white text-6xl font-bold text-red-900 border-8 border-red-700 rounded-2xl inline-block">{result}</div>}</div>);
}
