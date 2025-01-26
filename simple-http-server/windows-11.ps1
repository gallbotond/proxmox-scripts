# Define the port and the response message
$port = 8080
$responseMessage = "<html><body><h1>Hello, World!</h1></body></html>"

# Create a listener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:${port}/")
$listener.Start()
Write-Host "HTTP server started on port $port. Press Ctrl+C to stop."

# Create a ManualResetEvent to handle Ctrl+C
$stopEvent = New-Object System.Threading.ManualResetEvent $false

# Register an event handler for Ctrl+C
$null = [Console]::CancelKeyPress.Add({
    Write-Host "Stopping HTTP server..."
    $listener.Stop()
    $listener.Close()
    $stopEvent.Set()
})

# Handle incoming requests
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $response = $context.Response
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($responseMessage)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    }
} catch {
    Write-Host "HTTP server stopped."
} finally {
    # Stop the listener when done
    if ($listener.IsListening) {
        $listener.Stop()
    }
}

# Wait for the stop event
$stopEvent.WaitOne()