# Makefile

plan:
	mkdir -p data
	$(MAKE) -C terraform plan

apply:
	$(MAKE) -C terraform apply

destroy:
	$(MAKE) -C terraform destroy

clean:
	$(MAKE) -C terraform clean

.PHONY: plan apply clean
