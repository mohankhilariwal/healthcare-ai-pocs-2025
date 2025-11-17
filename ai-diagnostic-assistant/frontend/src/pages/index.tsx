import React, { useState } from 'react';
export default function Home() {
  const [input, setInput] = useState('40yo female, fever, dysuria, flank pain ×3 days');
  const [result, setResult] = useState(''); const [loading, setLoading] = useState(false);
  const call = async () => { setLoading(true);
    const res = await fetch('http://localhost:8002/diagnose', {method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({symptoms:input})});
    const d = await res.json(); setResult(d.diagnosis || JSON.stringify(d)); setLoading(false);
  };
  return (<div className="min-h-screen bg-blue-50 p-12 text-center"><h1 className="text-5xl font-bold text-blue-900 mb-8">AI Diagnostic Assistant</h1><textarea className="w-96 h-40 p-4 border-4 text-lg" value={input} onChange={e=>setInput(e.target.value)}/><br/><button onClick={call} disabled={loading} className="mt-8 px-16 py-8 bg-blue-700 text-white text-4xl rounded-xl">{loading?'Diagnosing…':'Diagnose'}</button>{result && <pre className="mt-12 p-10 bg-white text-xl border-4 border-blue-700 rounded-xl inline-block whitespace-pre-wrap">{result}</pre>}</div>);
}
