#!/bin/bash

export RDSHOST="mobius-sales-psql-1.c9oyct7ugcth.us-east-1.rds.amazonaws.com"
export PGPASSWORD="$(aws rds generate-db-auth-token --hostname $RDSHOST --port 5432 --region us-east-1 --username mobiussales )"
                    
psql "host=$RDSHOST port=5432 dbname=mobius_sales user=mobiussales password=$PGPASSWORD"

