.PHONY: clean clean-all clean-p1 clean-p2 clean-p3 clean-bonus

# Clean everything
clean-all: clean-p1 clean-p2 clean-p3 clean-bonus
	@echo "🧹 Cleaning root directory..."
	@if [ -f gitlab-values.yaml ]; then \
		rm gitlab-values.yaml; \
		echo "🗑️  Removed gitlab-values.yaml"; \
	fi
	@echo "✨ All cleanup completed!"

# Clean P1
clean-p1:
	@echo "🧹 Cleaning P1..."
	@if [ -d p1 ]; then \
		cd p1 && make clean; \
		echo "✨ P1 cleanup completed!"; \
	else \
		echo "⚠️  P1 directory not found"; \
	fi

# Clean P2
clean-p2:
	@echo "🧹 Cleaning P2..."
	@if [ -d p2 ]; then \
		cd p2 && make clean; \
		echo "✨ P2 cleanup completed!"; \
	else \
		echo "⚠️  P2 directory not found"; \
	fi

# Clean P3
clean-p3:
	@echo "🧹 Cleaning P3..."
	@if [ -d p3 ]; then \
		cd p3 && make clean; \
		echo "✨ P3 cleanup completed!"; \
	else \
		echo "⚠️  P3 directory not found"; \
	fi

# Clean Bonus
clean-bonus:
	@echo "🧹 Cleaning Bonus..."
	@if [ -d bonus ]; then \
		cd bonus && make clean; \
		echo "✨ Bonus cleanup completed!"; \
	else \
		echo "⚠️  Bonus directory not found"; \
	fi

# Default clean target
clean: clean-all 