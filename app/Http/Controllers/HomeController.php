<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class HomeController extends Controller
{
    public function index() {
        $latestEpisode = cache('latest');
        return view('index', compact('latestEpisode'));
    }
}
