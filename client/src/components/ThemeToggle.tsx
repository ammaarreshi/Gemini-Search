
import { Moon, Sun } from "lucide-react";
import { Button } from "./ui/button";
import { useEffect, useState } from "react";

export function ThemeToggle() {
  const [theme, setTheme] = useState("light");

  useEffect(() => {
    const detectTheme = () => window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
    // use stored theme or detect system preference
    const initialTheme = localStorage.getItem("theme") || detectTheme();
    setTheme(initialTheme);
    document.documentElement.classList.add(initialTheme);
  }, []);

  function toggleTheme() {
    const newTheme = theme === "light" ? "dark" : "light";
    document.documentElement.classList.replace(theme, newTheme);
    setTheme(newTheme);
    // Save the user's theme choice
    localStorage.setItem("theme", newTheme);
  }

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={toggleTheme}
      className="fixed top-4 right-4"
    >
      {theme === "light" ? (
        <Moon className="h-5 w-5" />
      ) : (
        <Sun className="h-5 w-5" />
      )}
    </Button>
  );
}
