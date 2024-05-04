<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class WebhookController extends Controller
{
    public function store(Request $request) {
        cache(['latest' => $request->all()], now()->addMinutes(5)); // cache for 1 day
        return response()->json(['status' => 'success']);
    }}
