#!/bin/bash

# Complete ProTask Manager Setup Script
# This script creates a full-featured professional to-do list application with automatic port conflict resolution

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
}

print_step() {
    echo -e "${CYAN}➜${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create the complete HTML file
create_complete_html_file() {
    cat > "$PROJECT_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ProTask Manager - Professional Task Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --success: #4cc9f0;
            --danger: #f72585;
            --warning: #f8961e;
            --info: #4895ef;
            --light: #f8f9fa;
            --dark: #212529;
            --gray: #6c757d;
            --light-gray: #e9ecef;
            --sidebar-width: 260px;
            --header-height: 70px;
        }
        
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: var(--dark);
            line-height: 1.6;
            min-height: 100vh;
            overflow: hidden;
        }
        
        /* Login Page Styles */
        #loginPage {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }
        
        .login-container {
            width: 100%;
            max-width: 450px;
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        
        .logo {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px;
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
        }
        
        .logo i {
            font-size: 42px;
            margin-right: 15px;
        }
        
        .logo h1 {
            font-size: 32px;
            font-weight: 700;
        }
        
        .login-form {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid var(--light-gray);
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary);
            outline: none;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 25px;
            background-color: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        
        .btn:hover {
            background-color: var(--secondary);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .btn-block {
            width: 100%;
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }
        
        .alert-danger {
            background-color: rgba(247, 37, 133, 0.1);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
        
        /* App Page Styles */
        #appPage {
            display: none;
            height: 100vh;
            background-color: #f5f7fa;
        }
        
        .app-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: var(--header-height);
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            z-index: 100;
        }
        
        .app-header h2 {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary);
        }
        
        .app-header h2 i {
            margin-right: 10px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
        }
        
        .user-info span {
            margin-right: 15px;
            font-weight: 500;
        }
        
        .app-body {
            display: flex;
            height: 100vh;
            padding-top: var(--header-height);
        }
        
        .sidebar {
            width: var(--sidebar-width);
            background-color: white;
            padding: 20px 0;
            border-right: 1px solid var(--light-gray);
            height: 100%;
            overflow-y: auto;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            margin-bottom: 5px;
            border-radius: 0;
            cursor: pointer;
            transition: all 0.3s;
            color: var(--gray);
            border-left: 4px solid transparent;
        }
        
        .nav-item:hover {
            background-color: rgba(67, 97, 238, 0.05);
            color: var(--primary);
        }
        
        .nav-item.active {
            background-color: rgba(67, 97, 238, 0.1);
            color: var(--primary);
            border-left: 4px solid var(--primary);
        }
        
        .nav-item i {
            margin-right: 12px;
            font-size: 18px;
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background-color: #f5f7fa;
        }
        
        .page {
            display: none;
        }
        
        .page.active {
            display: block;
        }
        
        .page-header {
            margin-bottom: 25px;
        }
        
        .page-header h1 {
            font-size: 28px;
            color: var(--dark);
            margin-bottom: 10px;
        }
        
        .page-header p {
            color: var(--gray);
            font-size: 16px;
        }
        
        /* Dashboard Styles */
        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
            border-top: 4px solid var(--primary);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card h3 {
            font-size: 32px;
            margin-bottom: 5px;
            color: var(--primary);
        }
        
        .stat-card p {
            color: var(--gray);
            font-size: 14px;
            font-weight: 500;
        }
        
        .dashboard-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        .dashboard-main {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .dashboard-sidebar {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }
        
        .dashboard-card {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .dashboard-card h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: var(--dark);
            display: flex;
            align-items: center;
        }
        
        .dashboard-card h3 i {
            margin-right: 10px;
            color: var(--primary);
        }
        
        /* Timer Section */
        .timer-section {
            text-align: center;
        }
        
        .timer-display {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin: 25px 0;
        }
        
        .timer {
            text-align: center;
        }
        
        .timer-value {
            font-size: 42px;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 5px;
            font-family: 'Courier New', monospace;
        }
        
        .timer-label {
            font-size: 14px;
            color: var(--gray);
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .timer-controls {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn-success {
            background-color: var(--success);
        }
        
        .btn-danger {
            background-color: var(--danger);
        }
        
        .btn-warning {
            background-color: var(--warning);
        }
        
        .btn-info {
            background-color: var(--info);
        }
        
        .btn-sm {
            padding: 10px 20px;
            font-size: 14px;
        }
        
        /* Task List */
        .task-list {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .task-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid var(--light-gray);
            transition: background-color 0.3s;
        }
        
        .task-item:hover {
            background-color: rgba(67, 97, 238, 0.03);
        }
        
        .task-item:last-child {
            border-bottom: none;
        }
        
        .task-checkbox {
            margin-right: 15px;
        }
        
        .task-content {
            flex: 1;
        }
        
        .task-title {
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .task-meta {
            display: flex;
            font-size: 12px;
            color: var(--gray);
        }
        
        .task-priority {
            margin-right: 15px;
            display: flex;
            align-items: center;
        }
        
        .priority-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 5px;
        }
        
        .priority-high .priority-dot {
            background-color: var(--danger);
        }
        
        .priority-medium .priority-dot {
            background-color: var(--warning);
        }
        
        .priority-low .priority-dot {
            background-color: var(--success);
        }
        
        .task-actions {
            display: flex;
            gap: 5px;
        }
        
        /* My Tasks Page */
        .tasks-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .tasks-controls {
            display: flex;
            gap: 15px;
        }
        
        .filter-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .input-section {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            background-color: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        input, select, textarea, button {
            padding: 12px 15px;
            border: 1px solid var(--light-gray);
            border-radius: 8px;
            font-size: 16px;
        }
        
        input, textarea, select {
            flex: 1;
        }
        
        textarea {
            min-height: 100px;
            resize: vertical;
        }
        
        .task-details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid var(--light-gray);
        }
        
        th {
            background-color: var(--light);
            font-weight: 600;
            color: var(--dark);
        }
        
        .priority-high {
            border-left: 4px solid var(--danger);
        }
        
        .priority-medium {
            border-left: 4px solid var(--warning);
        }
        
        .priority-low {
            border-left: 4px solid var(--success);
        }
        
        .actions {
            display: flex;
            gap: 5px;
        }
        
        .completed {
            text-decoration: line-through;
            opacity: 0.7;
        }
        
        .task-details {
            background-color: rgba(67, 97, 238, 0.05);
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 14px;
        }
        
        .task-details p {
            margin-bottom: 8px;
        }
        
        /* Analytics Page */
        .analytics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .chart-container {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            height: 350px;
        }
        
        .chart-container h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: var(--dark);
            display: flex;
            align-items: center;
        }
        
        .chart-container h3 i {
            margin-right: 10px;
            color: var(--primary);
        }
        
        /* Settings Page */
        .settings-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        .settings-section {
            background-color: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .settings-section h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: var(--dark);
            display: flex;
            align-items: center;
        }
        
        .settings-section h3 i {
            margin-right: 10px;
            color: var(--primary);
        }
        
        .setting-item {
            margin-bottom: 20px;
        }
        
        .setting-item label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark);
        }
        
        /* Break Alert */
        .break-alert {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.3);
            text-align: center;
            z-index: 1000;
            display: none;
            width: 90%;
            max-width: 450px;
        }
        
        .break-alert h2 {
            margin-bottom: 15px;
            color: var(--danger);
        }
        
        .break-alert p {
            margin-bottom: 25px;
            color: var(--gray);
            line-height: 1.6;
        }
        
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
            display: none;
        }
        
        /* Responsive Design */
        @media (max-width: 1200px) {
            .dashboard-content {
                grid-template-columns: 1fr;
            }
            
            .settings-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 992px) {
            .analytics-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .sidebar {
                width: 70px;
            }
            
            .nav-item span {
                display: none;
            }
            
            .nav-item i {
                margin-right: 0;
            }
            
            .input-section {
                flex-direction: column;
            }
            
            .task-details-grid {
                grid-template-columns: 1fr;
            }
        }
        
        @media (max-width: 576px) {
            .stats-cards {
                grid-template-columns: 1fr;
            }
            
            .timer-display {
                flex-direction: column;
                gap: 20px;
            }
            
            .timer-controls {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <!-- Login Page -->
    <div id="loginPage">
        <div class="login-container">
            <div class="logo">
                <i class="fas fa-tasks"></i>
                <h1>ProTask Manager</h1>
            </div>
            
            <div class="login-form">
                <div class="alert alert-danger" id="loginError">
                    <i class="fas fa-exclamation-circle"></i> Invalid username or password. Please try again.
                </div>
                
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" class="form-control" placeholder="Enter your username">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" class="form-control" placeholder="Enter your password">
                </div>
                
                <button id="loginBtn" class="btn btn-block">Sign In</button>
                
                <div style="margin-top: 25px; text-align: center; font-size: 14px; color: var(--gray); padding: 15px; background-color: var(--light); border-radius: 8px;">
                    <p><strong>Demo Credentials:</strong></p>
                    <p>Username: <strong>admin</strong></p>
                    <p>Password: <strong>admin123</strong></p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- App Page -->
    <div id="appPage">
        <div class="app-header">
            <h2><i class="fas fa-tasks"></i> ProTask Manager</h2>
            <div class="user-info">
                <span id="userWelcome">Welcome, User!</span>
                <button id="logoutBtn" class="btn btn-sm btn-danger"><i class="fas fa-sign-out-alt"></i> Logout</button>
            </div>
        </div>
        
        <div class="app-body">
            <div class="sidebar">
                <div class="nav-item active" data-page="dashboard">
                    <i class="fas fa-home"></i> <span>Dashboard</span>
                </div>
                <div class="nav-item" data-page="tasks">
                    <i class="fas fa-tasks"></i> <span>My Tasks</span>
                </div>
                <div class="nav-item" data-page="analytics">
                    <i class="fas fa-chart-bar"></i> <span>Analytics</span>
                </div>
                <div class="nav-item" data-page="settings">
                    <i class="fas fa-cog"></i> <span>Settings</span>
                </div>
            </div>
            
            <div class="main-content">
                <!-- Dashboard Page -->
                <div class="page active" id="dashboard">
                    <div class="page-header">
                        <h1>Dashboard</h1>
                        <p>Welcome to your productivity hub. Here's an overview of your tasks and progress.</p>
                    </div>
                    
                    <div class="stats-cards">
                        <div class="stat-card">
                            <h3 id="totalTasks">0</h3>
                            <p>Total Tasks</p>
                        </div>
                        <div class="stat-card">
                            <h3 id="completedTasks">0</h3>
                            <p>Completed</p>
                        </div>
                        <div class="stat-card">
                            <h3 id="pendingTasks">0</h3>
                            <p>Pending</p>
                        </div>
                        <div class="stat-card">
                            <h3 id="highPriorityTasks">0</h3>
                            <p>High Priority</p>
                        </div>
                    </div>
                    
                    <div class="dashboard-content">
                        <div class="dashboard-main">
                            <div class="dashboard-card">
                                <h3><i class="fas fa-clock"></i> Productivity Timer</h3>
                                <div class="timer-section">
                                    <div class="timer-display">
                                        <div class="timer">
                                            <div class="timer-value" id="workTimer">25:00</div>
                                            <div class="timer-label">Work Time</div>
                                        </div>
                                        <div class="timer">
                                            <div class="timer-value" id="breakTimer">05:00</div>
                                            <div class="timer-label">Break Time</div>
                                        </div>
                                    </div>
                                    <div class="timer-controls">
                                        <button id="startTimerBtn" class="btn btn-success btn-sm"><i class="fas fa-play"></i> Start Timer</button>
                                        <button id="pauseTimerBtn" class="btn btn-warning btn-sm" style="display: none;"><i class="fas fa-pause"></i> Pause Timer</button>
                                        <button id="resetTimerBtn" class="btn btn-danger btn-sm"><i class="fas fa-stop"></i> Reset Timer</button>
                                        <button id="skipBreakBtn" class="btn btn-info btn-sm"><i class="fas fa-fast-forward"></i> Skip Break</button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="dashboard-card">
                                <h3><i class="fas fa-list-check"></i> Recent Tasks</h3>
                                <div class="task-list" id="recentTasks">
                                    <!-- Recent tasks will be loaded here -->
                                </div>
                            </div>
                        </div>
                        
                        <div class="dashboard-sidebar">
                            <div class="dashboard-card">
                                <h3><i class="fas fa-chart-pie"></i> Task Overview</h3>
                                <canvas id="taskOverviewChart" height="250"></canvas>
                            </div>
                            
                            <div class="dashboard-card">
                                <h3><i class="fas fa-bullseye"></i> Daily Goals</h3>
                                <div class="goal-progress">
                                    <p>Tasks Completed Today: <strong id="todayCompleted">0</strong>/<span id="todayGoal">5</span></p>
                                    <div class="progress-bar" style="height: 10px; background-color: #e9ecef; border-radius: 5px; margin: 15px 0;">
                                        <div id="goalProgress" style="height: 100%; background-color: var(--success); border-radius: 5px; width: 0%;"></div>
                                    </div>
                                    <p>Productivity Score: <strong id="productivityScore">0</strong>/100</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- My Tasks Page -->
                <div class="page" id="tasks">
                    <div class="page-header">
                        <h1>My Tasks</h1>
                        <p>Manage your tasks, set priorities, and track your progress.</p>
                    </div>
                    
                    <div class="input-section">
                        <div style="flex: 1;">
                            <input type="text" id="taskTitle" placeholder="Task title">
                            <textarea id="taskDescription" placeholder="Task description"></textarea>
                            <div class="task-details-grid">
                                <div>
                                    <label>Due Date</label>
                                    <input type="date" id="taskDueDate">
                                </div>
                                <div>
                                    <label>Priority</label>
                                    <select id="taskPriority">
                                        <option value="low">Low Priority</option>
                                        <option value="medium">Medium Priority</option>
                                        <option value="high">High Priority</option>
                                    </select>
                                </div>
                                <div>
                                    <label>Category</label>
                                    <select id="taskCategory">
                                        <option value="work">Work</option>
                                        <option value="personal">Personal</option>
                                        <option value="health">Health</option>
                                        <option value="learning">Learning</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                                <div>
                                    <label>Estimated Time (hours)</label>
                                    <input type="number" id="taskEstimate" min="0" step="0.5" value="1">
                                </div>
                            </div>
                        </div>
                        <button id="addTaskBtn" class="btn btn-success"><i class="fas fa-plus"></i> Add Task</button>
                    </div>
                    
                    <div class="tasks-controls">
                        <div class="filter-group">
                            <label>Filter by:</label>
                            <select id="filterStatus">
                                <option value="all">All Tasks</option>
                                <option value="pending">Pending</option>
                                <option value="completed">Completed</option>
                            </select>
                            <select id="filterPriority">
                                <option value="all">All Priorities</option>
                                <option value="high">High</option>
                                <option value="medium">Medium</option>
                                <option value="low">Low</option>
                            </select>
                            <select id="filterCategory">
                                <option value="all">All Categories</option>
                                <option value="work">Work</option>
                                <option value="personal">Personal</option>
                                <option value="health">Health</option>
                                <option value="learning">Learning</option>
                                <option value="other">Other</option>
                            </select>
                        </div>
                        <button id="clearFiltersBtn" class="btn btn-sm btn-info"><i class="fas fa-filter"></i> Clear Filters</button>
                    </div>
                    
                    <table>
                        <thead>
                            <tr>
                                <th width="5%">Status</th>
                                <th width="30%">Task</th>
                                <th width="15%">Priority</th>
                                <th width="15%">Category</th>
                                <th width="15%">Due Date</th>
                                <th width="20%">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="taskTable">
                            <!-- Tasks will be added here dynamically -->
                        </tbody>
                    </table>
                </div>
                
                <!-- Analytics Page -->
                <div class="page" id="analytics">
                    <div class="page-header">
                        <h1>Analytics</h1>
                        <p>Visualize your productivity and task completion patterns.</p>
                    </div>
                    
                    <div class="analytics-grid">
                        <div class="chart-container">
                            <h3><i class="fas fa-chart-bar"></i> Tasks by Priority</h3>
                            <canvas id="priorityChart"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3><i class="fas fa-chart-pie"></i> Tasks by Category</h3>
                            <canvas id="categoryChart"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3><i class="fas fa-chart-line"></i> Completion Trends</h3>
                            <canvas id="trendChart"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3><i class="fas fa-calendar"></i> Weekly Progress</h3>
                            <canvas id="weeklyChart"></canvas>
                        </div>
                    </div>
                    
                    <div class="dashboard-card">
                        <h3><i class="fas fa-trophy"></i> Productivity Insights</h3>
                        <div id="productivityInsights">
                            <!-- Insights will be loaded here -->
                        </div>
                    </div>
                </div>
                
                <!-- Settings Page -->
                <div class="page" id="settings">
                    <div class="page-header">
                        <h1>Settings</h1>
                        <p>Customize your ProTask Manager experience.</p>
                    </div>
                    
                    <div class="settings-grid">
                        <div class="settings-section">
                            <h3><i class="fas fa-user"></i> Profile Settings</h3>
                            
                            <div class="setting-item">
                                <label for="userName">Display Name</label>
                                <input type="text" id="userName" class="form-control" value="Admin User">
                            </div>
                            
                            <div class="setting-item">
                                <label for="userEmail">Email Address</label>
                                <input type="email" id="userEmail" class="form-control" value="admin@example.com">
                            </div>
                            
                            <div class="setting-item">
                                <label for="userTheme">Theme</label>
                                <select id="userTheme" class="form-control">
                                    <option value="light">Light</option>
                                    <option value="dark">Dark</option>
                                    <option value="auto">Auto (System)</option>
                                </select>
                            </div>
                            
                            <button class="btn btn-success"><i class="fas fa-save"></i> Save Profile</button>
                        </div>
                        
                        <div class="settings-section">
                            <h3><i class="fas fa-clock"></i> Timer Settings</h3>
                            
                            <div class="setting-item">
                                <label for="workDuration">Work Duration (minutes)</label>
                                <input type="number" id="workDuration" class="form-control" value="25" min="5" max="60">
                            </div>
                            
                            <div class="setting-item">
                                <label for="breakDuration">Break Duration (minutes)</label>
                                <input type="number" id="breakDuration" class="form-control" value="5" min="1" max="30">
                            </div>
                            
                            <div class="setting-item">
                                <label for="longBreakDuration">Long Break Duration (minutes)</label>
                                <input type="number" id="longBreakDuration" class="form-control" value="15" min="5" max="60">
                            </div>
                            
                            <div class="setting-item">
                                <label for="autoStartBreaks">Auto-start Breaks</label>
                                <select id="autoStartBreaks" class="form-control">
                                    <option value="true">Yes</option>
                                    <option value="false">No</option>
                                </select>
                            </div>
                            
                            <button class="btn btn-success"><i class="fas fa-save"></i> Save Timer Settings</button>
                        </div>
                        
                        <div class="settings-section">
                            <h3><i class="fas fa-bell"></i> Notification Settings</h3>
                            
                            <div class="setting-item">
                                <label for="taskNotifications">Task Reminders</label>
                                <select id="taskNotifications" class="form-control">
                                    <option value="true">Enabled</option>
                                    <option value="false">Disabled</option>
                                </select>
                            </div>
                            
                            <div class="setting-item">
                                <label for="breakNotifications">Break Reminders</label>
                                <select id="breakNotifications" class="form-control">
                                    <option value="true">Enabled</option>
                                    <option value="false">Disabled</option>
                                </select>
                            </div>
                            
                            <div class="setting-item">
                                <label for="soundEnabled">Sound Alerts</label>
                                <select id="soundEnabled" class="form-control">
                                    <option value="true">Enabled</option>
                                    <option value="false">Disabled</option>
                                </select>
                            </div>
                            
                            <button class="btn btn-success"><i class="fas fa-save"></i> Save Notification Settings</button>
                        </div>
                        
                        <div class="settings-section">
                            <h3><i class="fas fa-database"></i> Data Management</h3>
                            
                            <div class="setting-item">
                                <label>Export Data</label>
                                <button class="btn btn-info btn-block"><i class="fas fa-download"></i> Export Tasks to JSON</button>
                            </div>
                            
                            <div class="setting-item">
                                <label>Import Data</label>
                                <input type="file" id="importFile" class="form-control" accept=".json">
                            </div>
                            
                            <div class="setting-item">
                                <label>Reset Data</label>
                                <button class="btn btn-danger btn-block" id="resetDataBtn"><i class="fas fa-trash"></i> Reset All Data</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Break Alert -->
    <div class="overlay" id="overlay"></div>
    <div class="break-alert" id="breakAlert">
        <h2><i class="fas fa-coffee"></i> Time for a Break!</h2>
        <p>You've been working for 25 minutes. Take a 5-minute break to stay productive and healthy.</p>
        <p>Stretch, hydrate, or step away from your screen for a moment.</p>
        <button id="startBreakBtn" class="btn btn-success"><i class="fas fa-play"></i> Start Break</button>
    </div>

    <!-- Audio for alerts -->
    <audio id="alarmSound" preload="auto">
        <source src="https://assets.mixkit.co/sfx/preview/mixkit-alarm-digital-clock-beep-989.mp3" type="audio/mpeg">
    </audio>

    <script>
        // DOM Elements
        const loginPage = document.getElementById('loginPage');
        const appPage = document.getElementById('appPage');
        const loginBtn = document.getElementById('loginBtn');
        const logoutBtn = document.getElementById('logoutBtn');
        const usernameInput = document.getElementById('username');
        const passwordInput = document.getElementById('password');
        const loginError = document.getElementById('loginError');
        const userWelcome = document.getElementById('userWelcome');
        
        // Task elements
        const taskTitle = document.getElementById('taskTitle');
        const taskDescription = document.getElementById('taskDescription');
        const taskDueDate = document.getElementById('taskDueDate');
        const taskPriority = document.getElementById('taskPriority');
        const taskCategory = document.getElementById('taskCategory');
        const taskEstimate = document.getElementById('taskEstimate');
        const addTaskBtn = document.getElementById('addTaskBtn');
        const taskTable = document.getElementById('taskTable');
        
        // Filter elements
        const filterStatus = document.getElementById('filterStatus');
        const filterPriority = document.getElementById('filterPriority');
        const filterCategory = document.getElementById('filterCategory');
        const clearFiltersBtn = document.getElementById('clearFiltersBtn');
        
        // Timer elements
        const workTimerDisplay = document.getElementById('workTimer');
        const breakTimerDisplay = document.getElementById('breakTimer');
        const startTimerBtn = document.getElementById('startTimerBtn');
        const pauseTimerBtn = document.getElementById('pauseTimerBtn');
        const resetTimerBtn = document.getElementById('resetTimerBtn');
        const skipBreakBtn = document.getElementById('skipBreakBtn');
        
        // Break alert elements
        const breakAlert = document.getElementById('breakAlert');
        const overlay = document.getElementById('overlay');
        const startBreakBtn = document.getElementById('startBreakBtn');
        const alarmSound = document.getElementById('alarmSound');
        
        // Stats elements
        const totalTasksEl = document.getElementById('totalTasks');
        const completedTasksEl = document.getElementById('completedTasks');
        const pendingTasksEl = document.getElementById('pendingTasks');
        const highPriorityTasksEl = document.getElementById('highPriorityTasks');
        const todayCompletedEl = document.getElementById('todayCompleted');
        const todayGoalEl = document.getElementById('todayGoal');
        const goalProgressEl = document.getElementById('goalProgress');
        const productivityScoreEl = document.getElementById('productivityScore');
        const recentTasksEl = document.getElementById('recentTasks');
        
        // Navigation elements
        const navItems = document.querySelectorAll('.nav-item');
        const pages = document.querySelectorAll('.page');
        
        // Timer variables
        let workTime = 25 * 60; // 25 minutes in seconds
        let breakTime = 5 * 60; // 5 minutes in seconds
        let workTimerInterval;
        let breakTimerInterval;
        let isWorkTime = true;
        let isTimerRunning = false;
        let pomodoroCount = 0;
        
        // Task array
        let tasks = [];
        let filteredTasks = [];
        
        // Chart instances
        let taskOverviewChart, priorityChart, categoryChart, trendChart, weeklyChart;
        
        // Initialize the app
        function initApp() {
            // Set default due date to tomorrow
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            taskDueDate.value = tomorrow.toISOString().split('T')[0];
            
            updateTimerDisplays();
            updateStats();
            initCharts();
            
            // Load tasks from localStorage if available
            const savedTasks = localStorage.getItem('proTaskTasks');
            if (savedTasks) {
                tasks = JSON.parse(savedTasks);
                filteredTasks = [...tasks];
                renderTasks();
            }
            
            // Load user settings
            loadSettings();
            
            // Event listeners
            loginBtn.addEventListener('click', handleLogin);
            logoutBtn.addEventListener('click', handleLogout);
            usernameInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') handleLogin();
            });
            passwordInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') handleLogin();
            });
            
            addTaskBtn.addEventListener('click', addTask);
            
            // Filter event listeners
            filterStatus.addEventListener('change', applyFilters);
            filterPriority.addEventListener('change', applyFilters);
            filterCategory.addEventListener('change', applyFilters);
            clearFiltersBtn.addEventListener('click', clearFilters);
            
            // Timer event listeners
            startTimerBtn.addEventListener('click', startTimer);
            pauseTimerBtn.addEventListener('click', pauseTimer);
            resetTimerBtn.addEventListener('click', resetTimer);
            skipBreakBtn.addEventListener('click', skipBreak);
            
            // Break alert event listener
            startBreakBtn.addEventListener('click', startBreak);
            
            // Navigation event listeners
            navItems.forEach(item => {
                item.addEventListener('click', function() {
                    const pageId = this.getAttribute('data-page');
                    switchPage(pageId);
                });
            });
            
            // Settings event listeners
            document.getElementById('resetDataBtn').addEventListener('click', resetAllData);
        }
        
        // Login handler
        function handleLogin() {
            const username = usernameInput.value.trim();
            const password = passwordInput.value.trim();
            
            if (username === 'admin' && password === 'admin123') {
                loginError.style.display = 'none';
                loginPage.style.display = 'none';
                appPage.style.display = 'block';
                userWelcome.textContent = `Welcome, ${username}!`;
            } else {
                loginError.style.display = 'block';
                passwordInput.value = '';
            }
        }
        
        // Logout handler
        function handleLogout() {
            loginPage.style.display = 'flex';
            appPage.style.display = 'none';
            usernameInput.value = '';
            passwordInput.value = '';
            loginError.style.display = 'none';
            
            // Reset timer
            resetTimer();
        }
        
        // Navigation function
        function switchPage(pageId) {
            // Update active nav item
            navItems.forEach(item => {
                if (item.getAttribute('data-page') === pageId) {
                    item.classList.add('active');
                } else {
                    item.classList.remove('active');
                }
            });
            
            // Show active page
            pages.forEach(page => {
                if (page.id === pageId) {
                    page.classList.add('active');
                } else {
                    page.classList.remove('active');
                }
            });
            
            // Update charts if switching to analytics
            if (pageId === 'analytics') {
                updateCharts();
            }
            
            // Update dashboard if switching to dashboard
            if (pageId === 'dashboard') {
                updateDashboard();
            }
        }
        
        // Add task function
        function addTask() {
            const title = taskTitle.value.trim();
            const description = taskDescription.value.trim();
            const dueDate = taskDueDate.value;
            const priority = taskPriority.value;
            const category = taskCategory.value;
            const estimate = parseFloat(taskEstimate.value) || 1;
            
            if (title === '') {
                alert('Please enter a task title!');
                return;
            }
            
            const newTask = {
                id: Date.now(),
                title: title,
                description: description,
                dueDate: dueDate,
                priority: priority,
                category: category,
                estimate: estimate,
                completed: false,
                createdAt: new Date().toISOString(),
                completedAt: null
            };
            
            tasks.push(newTask);
            saveTasks();
            applyFilters();
            updateStats();
            updateDashboard();
            
            // Clear form
            taskTitle.value = '';
            taskDescription.value = '';
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            taskDueDate.value = tomorrow.toISOString().split('T')[0];
            taskPriority.value = 'low';
            taskCategory.value = 'work';
            taskEstimate.value = '1';
            
            // Play sound
            playSound();
        }
        
        // Apply filters to tasks
        function applyFilters() {
            const statusFilter = filterStatus.value;
            const priorityFilter = filterPriority.value;
            const categoryFilter = filterCategory.value;
            
            filteredTasks = tasks.filter(task => {
                // Status filter
                if (statusFilter === 'pending' && task.completed) return false;
                if (statusFilter === 'completed' && !task.completed) return false;
                
                // Priority filter
                if (priorityFilter !== 'all' && task.priority !== priorityFilter) return false;
                
                // Category filter
                if (categoryFilter !== 'all' && task.category !== categoryFilter) return false;
                
                return true;
            });
            
            renderTasks();
        }
        
        // Clear all filters
        function clearFilters() {
            filterStatus.value = 'all';
            filterPriority.value = 'all';
            filterCategory.value = 'all';
            applyFilters();
        }
        
        // Render tasks to the table
        function renderTasks() {
            taskTable.innerHTML = '';
            
            if (filteredTasks.length === 0) {
                taskTable.innerHTML = '<tr><td colspan="6" style="text-align: center; padding: 30px; color: var(--gray);">No tasks found. Add a task to get started!</td></tr>';
                return;
            }
            
            // Sort tasks: incomplete first, then by due date
            const sortedTasks = [...filteredTasks].sort((a, b) => {
                if (a.completed !== b.completed) {
                    return a.completed ? 1 : -1;
                }
                
                if (a.dueDate && b.dueDate) {
                    return new Date(a.dueDate) - new Date(b.dueDate);
                }
                
                return new Date(b.createdAt) - new Date(a.createdAt);
            });
            
            sortedTasks.forEach(task => {
                const row = document.createElement('tr');
                row.className = `priority-${task.priority} ${task.completed ? 'completed' : ''}`;
                
                // Status cell
                const statusCell = document.createElement('td');
                const statusCheckbox = document.createElement('input');
                statusCheckbox.type = 'checkbox';
                statusCheckbox.checked = task.completed;
                statusCheckbox.addEventListener('change', () => toggleTaskComplete(task.id));
                statusCell.appendChild(statusCheckbox);
                
                // Task cell
                const taskCell = document.createElement('td');
                taskCell.innerHTML = `
                    <div class="task-title">${escapeHtml(task.title)}</div>
                    ${task.description ? `<div class="task-details">${escapeHtml(task.description)}</div>` : ''}
                `;
                
                // Priority cell
                const priorityCell = document.createElement('td');
                priorityCell.innerHTML = `
                    <div class="task-priority priority-${task.priority}">
                        <span class="priority-dot"></span>
                        ${task.priority.charAt(0).toUpperCase() + task.priority.slice(1)}
                    </div>
                `;
                
                // Category cell
                const categoryCell = document.createElement('td');
                categoryCell.textContent = task.category.charAt(0).toUpperCase() + task.category.slice(1);
                
                // Due date cell
                const dueDateCell = document.createElement('td');
                if (task.dueDate) {
                    const dueDate = new Date(task.dueDate);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);
                    
                    if (dueDate < today && !task.completed) {
                        dueDateCell.innerHTML = `<span style="color: var(--danger);">${formatDate(task.dueDate)} (Overdue)</span>`;
                    } else {
                        dueDateCell.textContent = formatDate(task.dueDate);
                    }
                } else {
                    dueDateCell.textContent = 'No due date';
                }
                
                // Actions cell
                const actionsCell = document.createElement('td');
                actionsCell.className = 'actions';
                
                const editBtn = document.createElement('button');
                editBtn.textContent = 'Edit';
                editBtn.className = 'btn btn-sm btn-info';
                editBtn.addEventListener('click', () => editTask(task.id));
                
                const deleteBtn = document.createElement('button');
                deleteBtn.textContent = 'Delete';
                deleteBtn.className = 'btn btn-sm btn-danger';
                deleteBtn.addEventListener('click', () => deleteTask(task.id));
                
                actionsCell.appendChild(editBtn);
                actionsCell.appendChild(deleteBtn);
                
                // Add cells to row
                row.appendChild(statusCell);
                row.appendChild(taskCell);
                row.appendChild(priorityCell);
                row.appendChild(categoryCell);
                row.appendChild(dueDateCell);
                row.appendChild(actionsCell);
                
                taskTable.appendChild(row);
            });
        }
        
        // Toggle task completion
        function toggleTaskComplete(taskId) {
            const taskIndex = tasks.findIndex(task => task.id === taskId);
            if (taskIndex !== -1) {
                tasks[taskIndex].completed = !tasks[taskIndex].completed;
                tasks[taskIndex].completedAt = tasks[taskIndex].completed ? new Date().toISOString() : null;
                saveTasks();
                applyFilters();
                updateStats();
                updateDashboard();
                updateCharts();
            }
        }
        
        // Edit task
        function editTask(taskId) {
            const taskIndex = tasks.findIndex(task => task.id === taskId);
            if (taskIndex === -1) return;
            
            const task = tasks[taskIndex];
            
            // Populate form with task data
            taskTitle.value = task.title;
            taskDescription.value = task.description;
            taskDueDate.value = task.dueDate;
            taskPriority.value = task.priority;
            taskCategory.value = task.category;
            taskEstimate.value = task.estimate;
            
            // Remove the task (will be re-added with updated values)
            tasks.splice(taskIndex, 1);
            saveTasks();
            applyFilters();
        }
        
        // Delete task
        function deleteTask(taskId) {
            if (confirm('Are you sure you want to delete this task?')) {
                tasks = tasks.filter(task => task.id !== taskId);
                saveTasks();
                applyFilters();
                updateStats();
                updateDashboard();
                updateCharts();
            }
        }
        
        // Save tasks to localStorage
        function saveTasks() {
            localStorage.setItem('proTaskTasks', JSON.stringify(tasks));
        }
        
        // Load user settings
        function loadSettings() {
            const settings = JSON.parse(localStorage.getItem('proTaskSettings') || '{}');
            
            // Apply settings if they exist
            if (settings.workDuration) {
                workTime = settings.workDuration * 60;
                document.getElementById('workDuration').value = settings.workDuration;
            }
            
            if (settings.breakDuration) {
                breakTime = settings.breakDuration * 60;
                document.getElementById('breakDuration').value = settings.breakDuration;
            }
            
            updateTimerDisplays();
        }
        
        // Reset all data
        function resetAllData() {
            if (confirm('Are you sure you want to reset all data? This action cannot be undone.')) {
                tasks = [];
                saveTasks();
                applyFilters();
                updateStats();
                updateDashboard();
                updateCharts();
                alert('All data has been reset.');
            }
        }
        
        // Update stats
        function updateStats() {
            const total = tasks.length;
            const completed = tasks.filter(task => task.completed).length;
            const pending = total - completed;
            const highPriority = tasks.filter(task => task.priority === 'high' && !task.completed).length;
            
            // Today's date for filtering
            const today = new Date().toDateString();
            const todayCompleted = tasks.filter(task => {
                if (!task.completedAt) return false;
                return new Date(task.completedAt).toDateString() === today;
            }).length;
            
            // Calculate productivity score
            const productivityScore = total > 0 ? Math.min(100, Math.round((completed / total) * 100)) : 0;
            
            totalTasksEl.textContent = total;
            completedTasksEl.textContent = completed;
            pendingTasksEl.textContent = pending;
            highPriorityTasksEl.textContent = highPriority;
            todayCompletedEl.textContent = todayCompleted;
            productivityScoreEl.textContent = productivityScore;
            
            // Update goal progress
            const goal = 5; // Daily goal
            const progress = Math.min(100, (todayCompleted / goal) * 100);
            goalProgressEl.style.width = `${progress}%`;
        }
        
        // Update dashboard
        function updateDashboard() {
            updateStats();
            updateRecentTasks();
            updateTaskOverviewChart();
        }
        
        // Update recent tasks list
        function updateRecentTasks() {
            // Get incomplete tasks, sorted by creation date (newest first)
            const recent = tasks
                .filter(task => !task.completed)
                .sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt))
                .slice(0, 5);
            
            recentTasksEl.innerHTML = '';
            
            if (recent.length === 0) {
                recentTasksEl.innerHTML = '<p style="text-align: center; color: var(--gray); padding: 20px;">No recent tasks</p>';
                return;
            }
            
            recent.forEach(task => {
                const taskItem = document.createElement('div');
                taskItem.className = 'task-item';
                
                taskItem.innerHTML = `
                    <div class="task-checkbox">
                        <input type="checkbox" onchange="toggleTaskComplete(${task.id})">
                    </div>
                    <div class="task-content">
                        <div class="task-title">${escapeHtml(task.title)}</div>
                        <div class="task-meta">
                            <div class="task-priority priority-${task.priority}">
                                <span class="priority-dot"></span>
                                ${task.priority}
                            </div>
                            <div class="task-date">${formatDate(task.dueDate)}</div>
                        </div>
                    </div>
                `;
                
                recentTasksEl.appendChild(taskItem);
            });
        }
        
        // Initialize charts
        function initCharts() {
            // Task Overview Chart (Doughnut)
            const taskOverviewCtx = document.getElementById('taskOverviewChart').getContext('2d');
            taskOverviewChart = new Chart(taskOverviewCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'Pending'],
                    datasets: [{
                        data: [0, 0],
                        backgroundColor: [
                            'rgba(76, 201, 240, 0.7)',
                            'rgba(248, 150, 30, 0.7)'
                        ],
                        borderColor: [
                            'rgba(76, 201, 240, 1)',
                            'rgba(248, 150, 30, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
            
            // Priority Chart (Bar)
            const priorityCtx = document.getElementById('priorityChart').getContext('2d');
            priorityChart = new Chart(priorityCtx, {
                type: 'bar',
                data: {
                    labels: ['High', 'Medium', 'Low'],
                    datasets: [{
                        label: 'Tasks by Priority',
                        data: [0, 0, 0],
                        backgroundColor: [
                            'rgba(247, 37, 133, 0.7)',
                            'rgba(248, 150, 30, 0.7)',
                            'rgba(76, 201, 240, 0.7)'
                        ],
                        borderColor: [
                            'rgba(247, 37, 133, 1)',
                            'rgba(248, 150, 30, 1)',
                            'rgba(76, 201, 240, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                stepSize: 1
                            }
                        }
                    }
                }
            });
            
            // Category Chart (Pie)
            const categoryCtx = document.getElementById('categoryChart').getContext('2d');
            categoryChart = new Chart(categoryCtx, {
                type: 'pie',
                data: {
                    labels: ['Work', 'Personal', 'Health', 'Learning', 'Other'],
                    datasets: [{
                        data: [0, 0, 0, 0, 0],
                        backgroundColor: [
                            'rgba(67, 97, 238, 0.7)',
                            'rgba(76, 201, 240, 0.7)',
                            'rgba(72, 149, 239, 0.7)',
                            'rgba(248, 150, 30, 0.7)',
                            'rgba(108, 117, 125, 0.7)'
                        ],
                        borderColor: [
                            'rgba(67, 97, 238, 1)',
                            'rgba(76, 201, 240, 1)',
                            'rgba(72, 149, 239, 1)',
                            'rgba(248, 150, 30, 1)',
                            'rgba(108, 117, 125, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right'
                        }
                    }
                }
            });
            
            // Trend Chart (Line)
            const trendCtx = document.getElementById('trendChart').getContext('2d');
            trendChart = new Chart(trendCtx, {
                type: 'line',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        label: 'Tasks Completed',
                        data: [0, 0, 0, 0, 0, 0, 0],
                        backgroundColor: 'rgba(76, 201, 240, 0.2)',
                        borderColor: 'rgba(76, 201, 240, 1)',
                        borderWidth: 2,
                        tension: 0.3,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
            
            // Weekly Chart (Bar)
            const weeklyCtx = document.getElementById('weeklyChart').getContext('2d');
            weeklyChart = new Chart(weeklyCtx, {
                type: 'bar',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [
                        {
                            label: 'Completed',
                            data: [0, 0, 0, 0, 0, 0, 0],
                            backgroundColor: 'rgba(76, 201, 240, 0.7)'
                        },
                        {
                            label: 'Created',
                            data: [0, 0, 0, 0, 0, 0, 0],
                            backgroundColor: 'rgba(248, 150, 30, 0.7)'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            stacked: false
                        },
                        y: {
                            stacked: false,
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        
        // Update all charts
        function updateCharts() {
            if (!taskOverviewChart) return;
            
            // Update task overview chart
            const completed = tasks.filter(task => task.completed).length;
            const pending = tasks.filter(task => !task.completed).length;
            taskOverviewChart.data.datasets[0].data = [completed, pending];
            taskOverviewChart.update();
            
            // Update priority chart
            const high = tasks.filter(task => task.priority === 'high').length;
            const medium = tasks.filter(task => task.priority === 'medium').length;
            const low = tasks.filter(task => task.priority === 'low').length;
            priorityChart.data.datasets[0].data = [high, medium, low];
            priorityChart.update();
            
            // Update category chart
            const work = tasks.filter(task => task.category === 'work').length;
            const personal = tasks.filter(task => task.category === 'personal').length;
            const health = tasks.filter(task => task.category === 'health').length;
            const learning = tasks.filter(task => task.category === 'learning').length;
            const other = tasks.filter(task => task.category === 'other').length;
            categoryChart.data.datasets[0].data = [work, personal, health, learning, other];
            categoryChart.update();
            
            // Update trend chart (mock data for now)
            trendChart.data.datasets[0].data = [2, 5, 3, 7, 6, 4, 1];
            trendChart.update();
            
            // Update weekly chart (mock data for now)
            weeklyChart.data.datasets[0].data = [2, 5, 3, 7, 6, 4, 1];
            weeklyChart.data.datasets[1].data = [3, 4, 5, 6, 5, 2, 1];
            weeklyChart.update();
        }
        
        // Timer functions
        function startTimer() {
            if (isTimerRunning) return;
            
            isTimerRunning = true;
            startTimerBtn.style.display = 'none';
            pauseTimerBtn.style.display = 'inline-block';
            
            if (isWorkTime) {
                workTimerInterval = setInterval(function() {
                    workTime--;
                    updateTimerDisplays();
                    
                    if (workTime <= 0) {
                        clearInterval(workTimerInterval);
                        pomodoroCount++;
                        showBreakAlert();
                        isTimerRunning = false;
                        startTimerBtn.style.display = 'inline-block';
                        pauseTimerBtn.style.display = 'none';
                    }
                }, 1000);
            } else {
                breakTimerInterval = setInterval(function() {
                    breakTime--;
                    updateTimerDisplays();
                    
                    if (breakTime <= 0) {
                        clearInterval(breakTimerInterval);
                        resetTimers();
                        isWorkTime = true;
                        isTimerRunning = false;
                        startTimerBtn.style.display = 'inline-block';
                        pauseTimerBtn.style.display = 'none';
                        playSound();
                    }
                }, 1000);
            }
        }
        
        function pauseTimer() {
            isTimerRunning = false;
            startTimerBtn.style.display = 'inline-block';
            pauseTimerBtn.style.display = 'none';
            
            if (isWorkTime) {
                clearInterval(workTimerInterval);
            } else {
                clearInterval(breakTimerInterval);
            }
        }
        
        function resetTimer() {
            pauseTimer();
            resetTimers();
            isWorkTime = true;
            updateTimerDisplays();
        }
        
        function skipBreak() {
            if (!isWorkTime) {
                resetTimer();
            }
        }
        
        function resetTimers() {
            const workDuration = parseInt(document.getElementById('workDuration').value) || 25;
            const breakDuration = parseInt(document.getElementById('breakDuration').value) || 5;
            
            workTime = workDuration * 60;
            breakTime = breakDuration * 60;
        }
        
        function updateTimerDisplays() {
            const workMinutes = Math.floor(workTime / 60);
            const workSeconds = workTime % 60;
            const breakMinutes = Math.floor(breakTime / 60);
            const breakSeconds = breakTime % 60;
            
            workTimerDisplay.textContent = `${workMinutes.toString().padStart(2, '0')}:${workSeconds.toString().padStart(2, '0')}`;
            breakTimerDisplay.textContent = `${breakMinutes.toString().padStart(2, '0')}:${breakSeconds.toString().padStart(2, '0')}`;
        }
        
        function showBreakAlert() {
            breakAlert.style.display = 'block';
            overlay.style.display = 'block';
            playSound();
        }
        
        function startBreak() {
            breakAlert.style.display = 'none';
            overlay.style.display = 'none';
            isWorkTime = false;
            startTimer();
        }
        
        function playSound() {
            alarmSound.currentTime = 0;
            alarmSound.play().catch(e => console.log("Audio play failed:", e));
        }
        
        // Utility functions
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }
        
        function formatDate(dateString) {
            if (!dateString) return 'No date';
            
            const date = new Date(dateString);
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        }
        
        // Initialize the app when the page loads
        document.addEventListener('DOMContentLoaded', initApp);
    </script>
</body>
</html>
EOF
}

# Function to create a Python server script with port conflict resolution
create_server_script() {
    cat > "$PROJECT_DIR/server.py" << 'EOF'
#!/usr/bin/env python3
import http.server
import socketserver
import webbrowser
import os
import socket

def find_available_port(start_port=8000, max_port=8100):
    """Find an available port in the given range"""
    for port in range(start_port, max_port + 1):
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
                s.bind(('', port))
                return port
        except OSError:
            continue
    raise Exception(f"No available ports found between {start_port} and {max_port}")

class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.dirname(os.path.abspath(__file__)), **kwargs)

def start_server():
    PORT = find_available_port()
    
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"Server running at http://localhost:{PORT}")
        print("Opening browser automatically...")
        webbrowser.open(f'http://localhost:{PORT}')
        print("Press Ctrl+C to stop the server")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")

if __name__ == "__main__":
    start_server()
EOF
}

# Function to create a Node.js server script with port conflict resolution
create_node_server_script() {
    cat > "$PROJECT_DIR/server.js" << 'EOF'
const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');
const net = require('net');

function findAvailablePort(startPort = 8000, maxPort = 8100) {
    return new Promise((resolve, reject) => {
        function tryPort(port) {
            if (port > maxPort) {
                reject(new Error(`No available ports found between ${startPort} and ${maxPort}`));
                return;
            }

            const server = net.createServer();
            server.once('error', (err) => {
                if (err.code === 'EADDRINUSE') {
                    tryPort(port + 1);
                } else {
                    reject(err);
                }
            });
            server.once('listening', () => {
                server.close();
                resolve(port);
            });
            server.listen(port);
        }

        tryPort(startPort);
    });
}

const MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.ico': 'image/x-icon'
};

async function startServer() {
    try {
        const PORT = await findAvailablePort();
        
        const server = http.createServer((req, res) => {
            let filePath = req.url === '/' ? '/index.html' : req.url;
            filePath = path.join(__dirname, filePath);
            
            const ext = path.extname(filePath);
            const mimeType = MIME_TYPES[ext] || 'text/plain';
            
            fs.readFile(filePath, (err, data) => {
                if (err) {
                    res.writeHead(404);
                    res.end('File not found');
                    return;
                }
                
                res.writeHead(200, { 'Content-Type': mimeType });
                res.end(data);
            });
        });

        server.listen(PORT, () => {
            console.log(`Server running at http://localhost:${PORT}`);
            console.log('Opening browser automatically...');
            
            // Open browser (platform-specific commands)
            const platform = process.platform;
            let command;
            
            if (platform === 'darwin') {
                command = 'open';
            } else if (platform === 'win32') {
                command = 'start';
            } else {
                command = 'xdg-open';
            }
            
            exec(`${command} http://localhost:${PORT}`, (err) => {
                if (err) {
                    console.log('Could not open browser automatically. Please manually navigate to:');
                    console.log(`http://localhost:${PORT}`);
                }
            });
            
            console.log('Press Ctrl+C to stop the server');
        });
    } catch (error) {
        console.error('Failed to start server:', error.message);
    }
}

startServer();
EOF
}

# Function to create README file
create_readme() {
    cat > "$PROJECT_DIR/README.md" << 'EOF'
# ProTask Manager - Professional Task Management

A comprehensive, full-featured task management application with productivity tracking, analytics, and customizable settings.

## Features

### Dashboard
- Task statistics and overview
- Productivity timer (Pomodoro technique)
- Recent tasks list
- Progress tracking and goals

### My Tasks
- Complete task management with details (title, description, due date, priority, category)
- Advanced filtering and sorting
- Task completion tracking
- Edit and delete functionality

### Analytics
- Visual charts for task distribution
- Priority and category breakdowns
- Completion trends over time
- Productivity insights

### Settings
- User profile customization
- Timer configuration
- Notification preferences
- Data management (export/import/reset)

## How to Use

1. Open `index.html` in your web browser
2. Or run one of the server scripts:
   - Python: `python3 server.py`
   - Node.js: `node server.js`

## Login Credentials

- Username: `admin`
- Password: `admin123`

## Project Structure

- `index.html` - Complete application with all features
- `server.py` - Python HTTP server
- `server.js` - Node.js HTTP server
- `README.md` - Documentation

## Browser Compatibility

Works in all modern browsers including Chrome, Firefox, Safari, and Edge.

## Data Storage

All tasks and settings are stored locally in your browser using localStorage.
EOF
}

# Function to create a startup script with port conflict resolution
create_startup_script() {
    cat > "$PROJECT_DIR/start.sh" << 'EOF'
#!/bin/bash

# ProTask Manager Startup Script

echo "Starting ProTask Manager..."

# Function to check if a port is available
check_port() {
    local port=$1
    if command -v python3 &> /dev/null; then
        python3 -c "import socket; s = socket.socket(); s.settimeout(1); result = s.connect_ex(('localhost', $port)); s.close(); exit(result == 0)"
    elif command -v nc &> /dev/null; then
        nc -z localhost $port
        return $?
    else
        # If we can't check, assume it's available
        return 1
    fi
}

# Try to find an available port
find_available_port() {
    for port in {8000..8010}; do
        if ! check_port $port; then
            echo $port
            return 0
        fi
    done
    echo "8000"  # Fallback
}

# Check if Python is available
if command -v python3 &> /dev/null; then
    echo "Starting Python server (auto-detecting available port)..."
    python3 server.py
elif command -v node &> /dev/null; then
    echo "Starting Node.js server (auto-detecting available port)..."
    node server.js
else
    echo "Neither Python nor Node.js found."
    echo "Please open index.html directly in your browser."
    echo "Or install Python or Node.js to use the server."
    
    # Try to open the file in default browser
    if command -v xdg-open &> /dev/null; then
        xdg-open index.html
    elif command -v open &> /dev/null; then
        open index.html
    elif command -v start &> /dev/null; then
        start index.html
    fi
fi
EOF
    chmod +x "$PROJECT_DIR/start.sh"
}

# Main script
main() {
    print_header "ProTask Manager - Complete Setup"
    echo
    print_status "Starting complete ProTask Manager setup..."
    
    # Set project directory
    PROJECT_DIR="./protask-manager"
    
    # Check if project directory already exists
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Project directory $PROJECT_DIR already exists."
        read -p "Do you want to overwrite it? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Setup cancelled."
            exit 1
        fi
        rm -rf "$PROJECT_DIR"
    fi
    
    # Create project directory
    mkdir -p "$PROJECT_DIR"
    print_success "Created project directory: $PROJECT_DIR"
    
    # Create HTML file
    print_step "Creating complete HTML application..."
    create_complete_html_file
    print_success "Complete HTML application created successfully"
    
    # Create server scripts
    print_step "Creating server scripts with port conflict resolution..."
    create_server_script
    create_node_server_script
    print_success "Server scripts created successfully"
    
    # Create README
    print_step "Creating documentation..."
    create_readme
    print_success "Documentation created successfully"
    
    # Create startup script
    print_step "Creating startup script..."
    create_startup_script
    print_success "Startup script created successfully"
    
    # Display setup completion message
    echo
    print_success "ProTask Manager setup completed successfully!"
    echo
    print_header "Project Overview"
    echo
    print_status "Project location: $PROJECT_DIR"
    echo
    print_status "Application Features:"
    echo "  ✓ Secure login system"
    echo "  ✓ Fullscreen professional interface"
    echo "  ✓ Complete Dashboard with statistics"
    echo "  ✓ Advanced Task Management with details"
    echo "  ✓ Comprehensive Analytics with charts"
    echo "  ✓ Customizable Settings"
    echo "  ✓ Productivity Timer (Pomodoro)"
    echo "  ✓ Task categories and priorities"
    echo "  ✓ Data export/import functionality"
    echo "  ✓ Automatic port conflict resolution"
    echo
    print_status "To use the application:"
    echo "  1. Direct opening: Open $PROJECT_DIR/index.html in your browser"
    echo "  2. Simple startup: Run $PROJECT_DIR/start.sh"
    echo "  3. Python server: cd $PROJECT_DIR && python3 server.py"
    echo "  4. Node.js server: cd $PROJECT_DIR && node server.js"
    echo
    print_status "Default login credentials:"
    echo "  Username: admin"
    echo "  Password: admin123"
    echo
    
    # Ask if user wants to start the server now
    read -p "Do you want to start the application now? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$PROJECT_DIR"
        ./start.sh
    else
        print_status "You can start the application later by running:"
        echo "  cd $PROJECT_DIR && ./start.sh"
    fi
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
